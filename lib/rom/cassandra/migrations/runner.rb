# encoding: utf-8

require "inflecto"

module ROM::Cassandra

  module Migrations

    # Base class that loads and runs the migration, registers it in
    # the Cassandra 'rom.migrations' table, and logs the result.
    #
    # As a base class uses the Command pattern to define a sequence of
    # actions, that should be implemented by the subclasses:
    # `RunnerUp`, and `RunnderDown`.
    #
    # @api private
    #
    class Runner

      # @!attribute [r] session
      #
      # @return [ROM::Cassandra::Session]
      #   The session for sending requests to Cassandra
      #
      attr_reader :session

      # @!attribute [r] logger
      #
      # @return [::Logger] The logger to report results
      #
      attr_reader :logger

      # @!attribute [r] version
      #
      # @return [Integer] The number of migration
      #
      attr_reader :version

      # @!attribute [r] path
      #
      # @return [String] The path to the migration file
      #
      attr_reader :path

      # @!attribute [r] migration
      #
      # @return [ROM::Cassandra::Migrations::Migration]
      #   The migration class
      #
      attr_reader :migration

      # Applies the runner to session, logger and migration path
      #
      # @param (see #initialize)
      #
      # @return (see #call)
      #
      def self.apply(session, logger, path)
        new(session, logger, path).call
      end

      # Initializes the runner for the session, logger and migration path
      #
      # @param [ROM::Cassandra::Session] session
      # @param [Logger] logger
      # @param [String] path
      #
      def initialize(session, logger, path)
        @session   = session
        @logger    = logger
        @path      = path
        @version   = extract_version
        @migration = extract_migration if migrate? # defined in a subclass
      end

      # Runs the sequence of commands to provide migration
      #
      # @return [undefined]
      #
      def call
        return unless migration
        apply    # defined in a subclass
        register # defined in a subclass
        log      # defined in a subclass
      end

      # Prepares the table and selects version
      #
      # @return [Array<Hash>] list of rows with the selected version
      #
      def select_version
        session.call "CREATE KEYSPACE IF NOT EXISTS rom WITH" \
          " REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 3};"
        session.call "CREATE TABLE IF NOT EXISTS rom.migrations" \
          " (version text, PRIMARY KEY (version));"
        session.call "SELECT * FROM rom.migrations WHERE" \
          " version = '#{version}';"
      end

      private

      def extract_version
        version = GET_VERSION[path]
        return version unless version.equal? 0
        fail NameError.new "invalid version number: '#{path}'"
      end

      def extract_migration
        require path
        basename   = File.basename(path, ".rb")
        class_name = Inflecto.camelize basename[/_.+/][1..-1]
        Inflecto.constantize(class_name).new(session)
      end

    end # class Runner

  end # module Migrations

end # module ROM::Cassandra
