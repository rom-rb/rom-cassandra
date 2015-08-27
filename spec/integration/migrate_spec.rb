# encoding: utf-8

describe "migrate" do

  # The helper function to check the db content
  def check(query)
    Cassandra.cluster.connect.execute query
  end

  let(:logger) { Logger.new stdout }
  let(:path)   { File.expand_path("../migrate", __FILE__) }

  # @change this 4 lines to ROM setup
  let(:klass)    { ROM::Cassandra::Migrations::Migrator }
  let(:session)  { ROM::Cassandra::Session.new "127.0.0.1:9042" }
  let(:stdout)   { StringIO.new }
  let(:migrator) { klass.new session, path: path, logger: logger }

  it "works" do
    expect { check "SELECT * FROM logs.users;" }.to raise_error StandardError
    expect { check "SELECT * FROM logs.logs" }.to raise_error StandardError
    expect(stdout.string).to be_empty

    migrator.apply version: 20150825142003

    expect { check "SELECT * FROM logs.users;" }.not_to raise_error
    expect { check "SELECT * FROM logs.logs" }.to raise_error StandardError
    expect(stdout.string).to     include "Apply migration 20150825142003"
    expect(stdout.string).not_to include "Apply migration 20150825142024"

    migrator.apply

    expect { check "SELECT * FROM logs.users;" }.not_to raise_error
    expect { check "SELECT * FROM logs.logs" }.not_to raise_error
    expect(stdout.string).to     include "Apply migration 20150825142024"
    expect(stdout.string).not_to include "Roll back"

    migrator.apply version: 0

    expect { check "SELECT * FROM logs.users;" }.to raise_error StandardError
    expect { check "SELECT * FROM logs.logs" }.to raise_error StandardError
    expect(stdout.string).to include "Roll back migration 20150825142024"
    expect(stdout.string).to include "Roll back migration 20150825142003"
  end

  after { check "DROP KEYSPACE IF EXISTS rom;" }
  after { check "DROP KEYSPACE IF EXISTS logs;" }

end # describe migrate
