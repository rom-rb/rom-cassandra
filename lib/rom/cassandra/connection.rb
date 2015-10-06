# encoding: utf-8

require "cassandra"

module ROM::Cassandra

  # Wraps the external driver, responsible for sending CQL requests
  # to the Cassandra cluster
  #
  class Connection

    # @!attribute [r] uri
    #
    # @return [Hash] the settings for the connection
    #
    attr_reader :uri

    # Initializes a connection to given cluster
    #
    # @param [Hash] options
    #
    def initialize(string = nil, hash = {})
      @uri   = Functions.fetch(:to_uri)[string].merge hash
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

  end # class Connection

end # module ROM::Cassandra
