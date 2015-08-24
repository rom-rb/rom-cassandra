# encoding: utf-8

module ROM::Cassandra

  module Migrations

    # Base class for migrations, responcible for sending queries to the session
    #
    # @example Migration can be created in OOP-style
    #   class CreateAuthUsers < ROM::Cassandra::Migration
    #     def up
    #       call keyspace(:auth).create.if_not_exists
    #       call keyspace(:auth)
    #         .table(:users)
    #         .create(:id, :int)
    #         .add(:name, :text)
    #         .primary_key(:id)
    #         .if_not_exists
    #     end
    #
    #     def down
    #       call keyspace(:auth).drop.if_exists
    #     end
    #   end
    #
    # @example The same migration in CQL style
    #   class CreateAuthUsers < ROM::Cassandra::Migration
    #     def up
    #       call "CREATE KEYSPACE IF NOT EXISTS auth;"
    #       call(
    #         "CREATE TABLE auth.users (id int, name text, PRIMARY KEY (text));"
    #       )
    #     end
    #
    #     def down
    #       call "DROM KEYSPACE IF EXISTS auth;"
    #     end
    #   end
    #
    class Migration

      # Makes all helper methods private
      #
      # @private
      #
      def self.inherited(klass)
        klass.__send__(:private, :call, :keyspace, :up, :down)
      end

      # Initializes migration with session to the Cassandra cluster
      #
      # @param [ROM::Cassandra::Session] session
      #
      def initialize(session)
        @session = session
        @builder = Query.new
      end

      # @!attribute [r] session
      #
      # @return [ROM::Cassandra::Session] the session to send queries to
      #
      attr_reader :session

      # By default does nothing
      #
      # @return [undefined]
      #
      # @abstract
      #
      def up
      end

      # By default does nothing
      #
      # @return [undefined]
      #
      # @abstract
      #
      def down
      end

      # Sends the query to Cassandra cluster
      #
      # @param [#to_s] query
      #
      # @return [Array]
      #
      def call(query)
        session.call query.to_s
      end

      # Starts building the CQL query in the context of some keyspace
      #
      # @param [#to_s] name
      #
      # @return [ROM::Cassandra::Query]
      #
      def keyspace(name)
        @builder.keyspace(name)
      end

    end # class Migration

  end # module Migrations

end # module ROM::Cassandra
