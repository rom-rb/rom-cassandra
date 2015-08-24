# encoding: utf-8

module ROM::Cassandra

  module Migrations

    # Runs migration up, registers it in Cassandra table and logs the change.
    #
    # @api private
    #
    class RunnerDown < Runner

      # Checks if the version hasn't been registered yet
      #
      # @return [Boolean]
      #
      def migrate?
        select_version.any?
      end

      # Rolls back the migration
      #
      # @return [undefined]
      #
      def apply
        migration.down
      end

      # Removes the version from Cassandra db
      #
      # @return [Array] an empty array
      #
      def register
        session.call "DELETE FROM rom.migrations WHERE version = '#{version}';"
      end

      # Logs the result of the operation
      #
      # @return [undefined]
      #
      def log
        logger.info "Roll back migration #{version}\n"
      end

    end # class RunnerDown

  end # module Migrations

end # module ROM::Cassandra
