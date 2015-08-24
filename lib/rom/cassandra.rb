# encoding: utf-8

require "rom"

# Ruby Object Mapper
#
# @see http://rom-rb.org ROM homepage
#
module ROM

  # Apache Cassandra support for ROM
  #
  # @see http://cassandra.apache.org/ Apache Cassandra project
  # @see http://datastax.github.io/ruby-driver/ Ruby driver for Cassandra
  # @see http://github.com/nepalez/query_builder CQL query builder
  #
  module Cassandra

    require_relative "cassandra/session"
    require_relative "cassandra/query"

    require_relative "cassandra/dataset"
    require_relative "cassandra/gateway"
    require_relative "cassandra/relation"
    require_relative "cassandra/commands"

    require_relative "cassandra/migrations"

  end # module Cassandra

  register_adapter(:cassandra, Cassandra)

end # module ROM
