# encoding: utf-8

module ROM::Cassandra

  module Commands

    # Implements the cassandra-specific Batch command
    #
    # @example
    #   class Batch < ROM::Cassandra::Batch
    #     relation :items
    #     register_as :batch
    #
    #     def execute
    #       super {
    #         self
    #           .add(keyspace(:domain).table(:items).delete.where(id: 1))
    #           .add("INSERT INTO logs.items (id, text) VALUES (1, 'deleted');")
    #       }
    #     end
    #   end
    #
    #   rom.command(:users).batch.call
    #
    # @api public
    #
    class Batch < ROM::Command

      include Executor

      adapter :cassandra
      option  :initial, default: true

      # Restricts the query by BATCH request
      #
      def initialize(*)
        super
        @relation = relation.batch_query if options[:initial]
      end

      # Returns the keyspace context for lazy queries.
      #
      # The method can be used within a block of [#execute] to prepare
      # array of commands for the batch.
      #
      # @param [#to_s] name The name of the keyspace
      #
      # @return [ROM::Cassandra::Query]
      #
      def keyspace(name)
        Query.new.keyspace(name)
      end

    end # class Create

  end # module Commands

end # module ROM::Cassandra
