# encoding: utf-8

module ROM::Cassandra

  module Commands

    # Implements the cassandra-specific Delete command
    #
    # @example
    #   class DeleteColumns < ROM::Commands::Delete[:cassandra]
    #     dataset(:users)
    #     register_as(:delete_columns)
    #
    #     def execute(id, *cols)
    #       super { delete(*cols).where(id: id).using(consistency: :quorum) }
    #     end
    #   end
    #
    #   delete_columns = rom.command(:users).delete_columns
    #   delete_columns.call(1, :text)
    #
    # @api public
    #
    class Delete < ROM::Commands::Delete

      include Executor # defines the `queries` and `execute` methods

      adapter :cassandra
      option  :initial, default: true

      # Restricts the query by DELETE request
      #
      def initialize(*)
        super
        @relation = relation.delete_query if options[:initial]
      end

    end # class Delete

  end # module Commands

end # module ROM::Cassandra
