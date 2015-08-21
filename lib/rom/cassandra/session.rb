# encoding: utf-8

require "cassandra"

module ROM::Cassandra

  # Wraps the external driver, responsible for sending CQL requests
  # to the Cassandra cluster
  #
  class Session

    # @!attribute [r] uri
    #
    # @return [Hash] the settings for the session
    #
    attr_reader :uri

    # Initializes a session to given cluster
    #
    # @param [Hash] uri
    #
    def initialize(uri)
      @uri  = uri
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

  end # class Session

end # module ROM::Cassandra
