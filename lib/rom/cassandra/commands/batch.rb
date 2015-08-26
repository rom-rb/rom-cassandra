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
    #       super do
    #         [
    #           keyspace(:domain).table(:items).delete.where(id: 1),
    #           keyspace(:logs).table(:items).insert(text: "deleted")
    #         ]
    #       end
    #     end
    #   end
    #
    #   rom.command(:users).batch.call
    #
    # @api public
    #
    class Batch < ROM::Command

      adapter :cassandra

      # @!attribute [r] dataset
      #
      # @return [ROM::Cassandra::Dataset] The dataset of the command's relation
      #
      attr_reader :dataset

      # @!attribute [r] query
      #
      # @return [ROM::Cassandra:Dataset]
      #   The [#dataset] restricted by BATCH queries
      #
      attr_reader :query

      # @private
      def initialize(*)
        super
        @dataset = relation.source
        @query   = dataset.batch
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

      # Executes the batch [#query]. Before execution yields the block,
      # that returns an array of commands, and adds it to the batch.
      #
      # @param [#to_s, Array<#to_s>] commands The batch content
      #
      # @return [Array]
      #   An empty array `[]` (Cassandra does't read data while writing)
      #
      def execute(*commands)
        commands.inject(query, :add).to_a
      end

    end # class Create

  end # module Commands

end # module ROM::Cassandra
