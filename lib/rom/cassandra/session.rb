# encoding: utf-8

require "cassandra"

module ROM::Cassandra

  # Wraps the external driver, responsible for sending CQL requests
  # to the Cassandra cluster
  #
  class Session

    # The regexp, describing the format of the allowed address of the cluster
    FORMAT = /\d{1,3}(\.\d{1,3}){3}(\:\d+)?/

    # @!attribute [r] uri
    #
    # @return [Hash] the settings for the session
    #
    attr_reader :uri

    # Initializes a session to given cluster
    #
    # @param [Hash] options
    #
    def initialize(*options)
      @uri  = extract(*options)
      @conn = ::Cassandra.cluster(uri).connect
    end

    # Sends the query to the Cassandra syncronously
    #
    # @param [#to_s] query
    #
    # @return [Array<Hash>]
    #
    def call(query)
      @conn.execute(query.to_s).to_a
    end

    private

    def extract(uri = { hosts: ["127.0.0.1"], port: 9042 }, hash = {})
      return uri if uri.instance_of? Hash
      hosts, port = uri[FORMAT].split(":")
      { hosts: [hosts], port: port.to_i }.merge hash
    end

  end # class Session

end # module ROM::Cassandra
