# encoding: utf-8

require "logger"

module ROM::Cassandra

  module Migrations

    # Default Logger for the migrator
    #
    # @example
    #   logger = Logger.new
    #   logger.info "some text"
    #   # => some text
    #
    class Logger < ::Logger

      # @private
      def initialize
        super $stdout
        self.formatter = proc { |_, _, _, message| "#{message}\n" }
      end

    end # Logger

  end # module Migrations

end # module ROM::Cassandra
