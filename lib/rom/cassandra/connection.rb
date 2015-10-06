# encoding: utf-8

require "cassandra"

module ROM::Cassandra

  # Wraps the external driver, responsible for sending CQL requests
  # to the Cassandra cluster
  #
  class Connection

    # The regexp, describing the format of the allowed address of the cluster
    FORMAT = /\d{1,3}(\.\d{1,3}){3}(\:\d+)?/

    # @!attribute [r] uri
    #
    # @return [Hash] the settings for the connection
    #
    attr_reader :uri

    # Initializes a connection to given cluster
    #
    # @param [Hash] options
    #
    def initialize(*options)
      @uri  = extract(*options)
      @conn  = ::Cassandra.cluster(uri).connect
      @mutex = Mutex.new
    end

    # Sends the query to the Cassandra syncronously in thread-safe manner
    #
    # The underlying (third party) connection is potentially stateful,
    # that's why +@mutex+ variable locks the call.
    #
    # @param [#to_s] query
    #
    # @return [Array<Hash>]
    #
    def call(query)
      @mutex.synchronize { @conn.execute(query.to_s) }.to_a
    end

    private

    def extract(uri = { hosts: ["127.0.0.1"], port: 9042 }, hash = {})
      return uri if uri.instance_of? Hash
      hosts, port = uri[FORMAT].split(":")
      { hosts: [hosts], port: port.to_i }.merge hash
    end

  end # class Connection

end # module ROM::Cassandra
