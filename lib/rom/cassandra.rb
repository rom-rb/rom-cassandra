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

  end # module Cassandra

  register_adapter(:cassandra, Cassandra)

end # module ROM
