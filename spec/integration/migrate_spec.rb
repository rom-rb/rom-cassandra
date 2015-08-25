# encoding: utf-8

describe "migrate" do

  def call(query)
    Cassandra.cluster.connect.execute query
  end

  before { $stdout = StringIO.new }
  after  { $stdout = STDOUT }
  after  { call "DROP KEYSPACE IF EXISTS rom;" }
  after  { call "DROP KEYSPACE IF EXISTS logs;" }

  let(:migrator) { klass.new hosts: ["127.0.0.1"], port: 9042, path: path }
  let(:klass)    { ROM::Cassandra::Migrations::Migrator }
  let(:path)     { File.expand_path("../migrate", __FILE__) }

  it "works" do
    expect { call "SELECT * FROM logs.users;" }.to raise_error StandardError
    expect { call "SELECT * FROM logs.logs" }.to raise_error StandardError

    migrator.apply version: 20150825142003

    expect { call "SELECT * FROM logs.users;" }.not_to raise_error
    expect { call "SELECT * FROM logs.logs" }.to raise_error StandardError

    migrator.apply

    expect { call "SELECT * FROM logs.users;" }.not_to raise_error
    expect { call "SELECT * FROM logs.logs" }.not_to raise_error

    migrator.apply version: 0

    expect { call "SELECT * FROM logs.users;" }.to raise_error StandardError
    expect { call "SELECT * FROM logs.logs" }.to raise_error StandardError
  end

end # describe migrate
