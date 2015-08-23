# encoding: utf-8

module ROM::Cassandra

  module Commands

    # Defines methods shared by standard ROM commands (Create, Update, Delete).
    #
    module Executor

      # @!attribute [r] query
      #
      # @return [ROM::Cassandra::Dataset]
      #   The dataset carried by the command, prepared for a specific type
      #   (INSERT, UPDATE, DELETE) of statements.
      #
      attr_reader :query

      # @!attribute [r] dataset
      #
      # @return [ROM::Cassandra::Dataset] The dataset of the relation
      #
      def dataset
        relation.dataset
      end

      # Implements the execute method of the `ROM::Command` abstract class
      #
      # @yield the block in the scope of the [#query] to specify the statement.
      #
      # @return [Array]
      #   The empty array (Cassandra doesn't select rows when writes data).
      #
      def execute(*, &block)
        updated = block_given? ? query.instance_eval(&block) : query
        updated.to_a
      end

    end # module Executor

  end # module Commands

end # module ROM::Cassandra
