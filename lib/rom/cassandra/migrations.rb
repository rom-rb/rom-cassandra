# encoding: utf-8

require "logger"

module ROM::Cassandra

  # Migrations features for the Cassandra cluster
  #
  module Migrations

    # The procedure that extracts version number from a migration filename
    GET_VERSION  = -> name { File.basename(name, ".rb")[/\d{14}/].to_i }

    # The default path for migrations
    DEFAULT_PATH = "db/migrate".freeze

    # The biggest possible version for migrations
    ALL_VERSIONS = ("9" * 14).to_i

    require_relative "migrations/logger"

  end # module Migrations

end # module ROM::Cassandra
