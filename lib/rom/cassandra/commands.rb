# encoding: utf-8

module ROM::Cassandra

  # The collection of Cassandra-specific ROM commands
  #
  # @api public
  #
  module Commands

    require_relative "commands/executor"
    require_relative "commands/create"

  end # module Commands

end # module ROM::Cassandra
