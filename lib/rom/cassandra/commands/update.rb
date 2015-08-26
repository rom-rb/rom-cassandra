# encoding: utf-8

module ROM::Cassandra

  module Commands

    # Implements the cassandra-specific Update command
    #
    # @example
    #   class UpdateName < ROM::Commands::Update[:cassandra]
    #     relation :items
    #     register_as :update_name
    #
    #     def execture(id, name)
    #       super { set(name: name).where(id: id).using(consistency: :quorum) }
    #     end
    #   end
    #
    #   update_name = rom.command(:users).update_name
    #   update_name.call(1, "Andrew")
    #
    # @api public
    #
    class Update < ROM::Commands::Update

      include Executor # defines the `queries` and `execute` methods

      adapter :cassandra
      option  :initial, default: true

      # Restricts the query by UPDATE request
      #
      def initialize(*)
        super
        @relation = relation.update_query if options[:initial]
      end

    end # class Create

  end # module Commands

end # module ROM::Cassandra
