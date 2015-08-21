# encoding: utf-8

require "cassandra"

RSpec.configure do |config|

  # Prepares table auth.users using official Datastax ruby driver for Cassandra
  #
  # Populates table records [{id: 1, name: "joe"}, {id: 2, name: "jane"}]
  #
  def reset_cluster
    [
      "DROP KEYSPACE IF EXISTS auth;",
      "CREATE KEYSPACE auth WITH " \
        "replication = {'class': 'SimpleStrategy', 'replication_factor': 1};",
      "CREATE TABLE auth.users (id int, name text, PRIMARY KEY (id));",
      "INSERT INTO auth.users (id, name) VALUES (1, 'joe');",
      "INSERT INTO auth.users (id, name) VALUES (2, 'jane');"
    ].each(&::Cassandra.cluster.connect.method(:execute))
  end

  # Prepares the cluster before the suit
  reset_cluster

  # Recreates cluster after every example, marked by :reset_cluster tag
  config.after(:example, :reset_cluster) { reset_cluster }

end # RSpec.configure
