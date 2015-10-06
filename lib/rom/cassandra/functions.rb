# encoding: utf-8

module ROM::Cassandra

  # Registry of gem-specific pure functions (transprocs)
  #
  # @author nepalez <andrew.kozin@gmail.com>
  #
  module Functions

    extend Transproc::Registry

    import :accept_keys, from: Transproc::HashTransformations, as: :slice

    # Regex to extract host and port from string
    URI_FORMAT  = /\d{1,3}(\.\d{1,3}){3}(\:\d+)?|\:\d{1,5}/
    DEFAULT_URI = { hosts: ["127.0.0.1"], port: 9042 }.freeze

    # Converts string or hash describing uri into valid representation of uri
    #
    # @example
    #   fn = ROM::Cassandra::Functions[:to_uri]
    #
    #   fn["127.0.0.2:9042"]
    #   # => { hosts: ["127.0.0.2"], port: 9042 }
    #
    #   fn[hosts: ["127.0.0.1", "127.0.0.2"], port: 9042]
    #   # => { hosts: ["127.0.0.1", "127.0.0.2"], port: 9042 }
    #
    #   fn[] # by default
    #   # => { hosts: ["127.0.0.1"], port: 9042 }
    #
    # @param [Hash, #to_s] value
    #
    # @return [Hash]
    #
    def self.to_uri(value)
      value.instance_of?(Hash) ? hash_to_uri(value) : string_to_uri(value.to_s)
    end

    private

    def self.hash_to_uri(hash)
      uri = fetch(:slice)[hash, [:hosts, :port]]

      hash.merge(DEFAULT_URI).merge(uri)
    end

    def self.string_to_uri(string)
      host, port = string[URI_FORMAT].to_s.split(":")

      uri = port ? { port: port.to_i } : {}
      uri[:hosts] = [host] unless host.to_s.empty?
      DEFAULT_URI.merge(uri)
    end

  end # module Functions

end # module ROM::Cassandra
