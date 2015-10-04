# encoding: utf-8

module ROM::Cassandra

  # The dataset describes a table of the Cassandra cluster
  #
  # @api private
  #
  class Dataset

    include Enumerable
    include Equalizer.new(:gateway, :keyspace, :table, :query)

    # @!attribute [r] gateway
    #
    # @return [ROM::Cassandra::Session] The gateway to a Cassandra cluster
    #
    attr_reader :gateway

    # @!attribute [r] keyspace
    #
    # @return [Symbol] The name of the current keyspace
    #
    attr_reader :keyspace

    # @!attribute [r] table
    #
    # @return [Symbol] The name of the current table
    #
    attr_reader :table

    # @!attribute [r] query
    #
    # @return [QueryBuilder::Statement] The lazy query to the current table
    #
    attr_reader :query

    # Initializes the dataset for given column family and command options
    #
    # @param [ROM::Cassandra::Gateway] gateway
    # @param [#to_sym] keyspace
    # @param [#to_sym] table
    # @param [ROM::Cassandra::Query] query
    #
    # @api private
    #
    def initialize(gateway, keyspace, table, query = nil)
      @gateway  = gateway
      @keyspace = keyspace.to_sym if keyspace
      @table    = table.to_sym if table
      @query    = query || Query.new.keyspace(keyspace).table(table)
    end

    # Returns the new dataset carriyng the batch query
    #
    # The batch query doesn't restricted by any table or keyspace
    #
    # @return [ROM::Relation::Dataset]
    #
    def batch
      reload nil, nil, Query.new.batch
    end

    # Returns new dataset with `select` method applied to the [#query]
    #
    # @param [Array, Hash, nil] args
    #
    # @return [ROM::Relation::Dataset]
    #
    def get(*args)
      reload keyspace, table, query.select(*args)
    end

    # Sends the [#query] to Cassandra and iterates through results
    #
    # @return [Enumerator]
    #
    # @yieldparam [Hash] tuples from the dataset
    # @yieldreturn [self] itself
    #
    def each
      return to_enum unless block_given?
      gateway.call(query).each { |item| yield(item) }
    end

    private

    def reload(*args)
      self.class.new(gateway, *args)
    end

    def method_missing(name, *args)
      reload keyspace, table, query.public_send(name, *args)
    end

    def respond_to_missing?(name, *)
      query.respond_to?(name)
    end

  end # class Dataset

end # module ROM::Cassandra
