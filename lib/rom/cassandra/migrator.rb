# encoding: utf-8

module ROM::Cassandra

  # Cassandra-specific migrator
  #
  # @author nepalez <andrew.kozin@gmail.com>
  #
  class Migrator < ROM::Migrator

    # Creates the 'rom' keyspace with 'migrations' table to store applied
    # migrations in the current persistence.
    #
    # @return [undefined]
    #
    def prepare_registry
      call "CREATE KEYSPACE IF NOT EXISTS rom WITH REPLICATION =" \
           " {'class': 'SimpleStrategy', 'replication_factor': 3};"
      call "CREATE TABLE IF NOT EXISTS rom.migrations " \
           "(version text, PRIMARY KEY (version));"
    end

    # Registers the number in 'rom:migrations' table
    #
    # @param [#to_s] number The number of migration being applied
    #
    # @return [undefined]
    #
    def register(number)
      call "INSERT INTO rom.migrations (version) VALUES ('#{number}');"
    end

    # Unregisters the number in 'rom:migrations' table
    #
    # @param [#to_s] number The number of migration being rolled back
    #
    # @return [undefined]
    #
    def unregister(number)
      call "DELETE FROM rom.migrations WHERE version = '#{number}';"
    end

    # Returns the list of applied migrations' numbers
    #
    # @return [Array<String>]
    #
    def registered
      call("SELECT version FROM rom.migrations;")
        .map { |item| item.fetch("version") }
    end

    # Sends the query to Cassandra cluster
    #
    # @param [String] query
    #
    # @return [Array<Hash>]
    #
    def call(query)
      gateway.call(query)
    end

    # Starts building a CQL query
    #
    # @param [#to_s] name The name of the keyspace
    #
    # @return [String]
    #
    def keyspace(name)
      Query.new.keyspace(name)
    end

  end # class Migrator

end # module ROM::Cassandra
