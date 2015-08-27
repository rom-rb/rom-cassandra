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

      include Commands

      private

      def restriction
        :update_query
      end

    end # class Create

  end # module Commands

end # module ROM::Cassandra
