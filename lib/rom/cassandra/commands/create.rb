# encoding: utf-8

module ROM::Cassandra

  module Commands

    # Implements the cassandra-specific Create command
    #
    # @example
    #   class CreateName < ROM::Commands::Create[:cassandra]
    #     relation :items
    #     register_as :create
    #
    #     def execute(id, name)
    #       super { insert(id: id, name: name).using(consistency: :quorum) }
    #     end
    #   end
    #
    #   create = rom.command(:users).create
    #   create.call(1, "Andrew")
    #
    # @api public
    #
    class Create < ROM::Commands::Create

      include Executor

      adapter :cassandra
      option  :initial, default: true

      # Restricts the query by INSERT request
      #
      def initialize(*)
        super
        @relation = relation.insert_query if options.fetch(:initial)
      end

    end # class Create

  end # module Commands

end # module ROM::Cassandra
