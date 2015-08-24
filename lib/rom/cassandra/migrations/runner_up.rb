# encoding: utf-8

module ROM::Cassandra

  module Migrations

    # Runs migration up, registers it in Cassandra table and logs the change.
    #
    # @api private
    #
    class RunnerUp < Runner

      # Checks if the version has been registered yet
      #
      # @return [Boolean]
      #
      def migrate?
        select_version.empty?
      end

      # Moves the migration forward
      #
      # @return [undefined]
      #
      def apply
        migration.up
      end

      # Registers the version in Cassandra db
      #
      # @return [Array] an empty array
      #
      def register
        session.call "INSERT INTO rom.migrations (version)" \
          " VALUES ('#{version}');"
      end

      # Logs the result of the operation
      #
      # @return [undefined]
      #
      def log
        logger.info "Apply migration #{version}\n"
      end

    end # class RunnerUp

  end # module Migrations

end # module ROM::Cassandra
