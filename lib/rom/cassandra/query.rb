# encoding: utf-8

require "query_builder"

module ROM::Cassandra

  # Wraps the external CQL query builder
  #
  class Query

    # Default CQL statements builder
    DEFAULT_BUILDER = QueryBuilder::CQL

    # Initializes the object carrying the lazy query
    #
    # @param [ROM::Cassandra::Query] query
    #
    def initialize(query = nil)
      @query = query || DEFAULT_BUILDER
    end

    # Builds the Query statement from the wrapped query
    #
    # @return [String]
    #
    def to_s
      @query.to_s
    end

    private

    def respond_to_missing?(name, *)
      @query.respond_to? name
    end

    def method_missing(name, *args)
      updated_query = @query.public_send(name, *args)
      self.class.new(updated_query)
    end

  end # class Query

end # module ROM::Cassandra
