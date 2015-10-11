# encoding: utf-8

module ROM::Cassandra

  # Wraps the external CQL query builder
  #
  class Query

    include Immutability # defines __update__

    # Builds lazy query restricted by keyspace
    #
    # @param [#to_s] name
    #
    # @return [ROM::Cassandra::Query]
    #
    def self.keyspace(keyspace)
      new.keyspace(keyspace)
    end

    # Builds lazy query restricted by keyspace and table
    #
    # @param [#to_s] keyspace
    # @param [#to_s] name
    #
    # @return [ROM::Cassandra::Query]
    #
    def self.table(keyspace, name)
      keyspace(keyspace).table(name)
    end

    # Builds lazy batch query
    #
    # @return [ROM::Cassandra::Query]
    #
    def self.batch
      new.batch
    end

    # Initializes the object carrying the empty lazy query
    #
    def initialize
      @query = QueryBuilder::CQL
    end

    # Builds the Query statement from the wrapped query
    #
    # @return [String]
    #
    def to_s
      @query.to_s
    end

    private

    # Sends all unknown methods to the current query and returns
    # new object carrying updated query
    #
    def method_missing(*args)
      __update__ { @query = @query.public_send(*args) }
    end

    def respond_to_missing?(name, *)
      @query.respond_to? name
    end

  end # class Query

end # module ROM::Cassandra
