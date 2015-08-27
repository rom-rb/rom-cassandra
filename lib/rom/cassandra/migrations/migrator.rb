# encoding: utf-8

module ROM::Cassandra

  module Migrations

    # Class Migrator finds the migration files and migrates Cassandra cluster
    # to the required version using method [#apply].
    #
    # The class is responcible for searching files and deciding,
    # which of them should be runned up and down. Every single migration
    # is applied or rolled back using `RunnerUp` and `RunnerDown` classes.
    #
    # @example
    #   migrator = Migrator.new(hosts: ["127.0.0.1"], port: 9042)
    #
    #   # Applies all migrations
    #   migrator.apply
    #
    #   # Rolls back all migrations
    #   migrator.apply version: 0
    #
    #   # Moves to the required version (before the year 2016)
    #   migrator.apply version: 20151231235959
    #
    class Migrator

      # @!attribute [r] session
      #
      # @return [ROM::Cassandra::Session] The session to the Cassandra cluster
      #
      attr_reader :session

      # @!attribute [r] logger
      #
      # @return [::Logger] The logger used by the migrator
      #
      attr_reader :logger

      # @!attribute [r] root
      #
      # @return [Array<String>] The root path for migrations
      #
      attr_reader :root

      # @!attribute [r] paths
      #
      # @return [Array<String>] The list of paths to migration files
      #
      attr_reader :paths

      # Initializes a migrator with Cassandra uri settings.
      #
      # Can specify logger and path as well.
      #
      # @param [ROM::Cassandra::Session] session
      # @option options [::Logger] :logger
      # @option options [String] :path
      #
      # See [ROM::Cassandra::Session] for other avaliable options for URI
      #
      def initialize(session, options = {})
        @session = session
        @logger  = options.fetch(:logger) { Logger.new }
        @root    = options.fetch(:path) { DEFAULT_PATH }
        @paths   = Dir[File.join(root, "*.rb")]
      end

      # Migrates the Cassandra cluster to selected version
      #
      # Applies all migrations if a version is skipped.
      # Rolls all migrations back if a version is set to 0.
      #
      # @option options [Integer, nil] :version
      #
      # @return [undefined]
      #
      def apply(options = {})
        version = options.fetch(:version) { ALL_VERSIONS }

        migrate_to version
        rollback_to version
      end

      private

      def migrate_to(version)
        paths
          .reject { |path| GET_VERSION[path] > version }
          .each { |path| RunnerUp.apply(session, logger, path) }
      end

      def rollback_to(version)
        paths
          .select { |path| GET_VERSION[path] > version }
          .reverse_each { |path| RunnerDown.apply(session, logger, path) }
      end

    end # class Migrator

  end # module Migrations

end # module ROM::Cassandra
