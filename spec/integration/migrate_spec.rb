# encoding: utf-8

describe "migrator" do

  # The helper function to check the db content
  def check(query)
    Cassandra.cluster.connect.execute query
  end

  let(:stdout)   { StringIO.new }
  let(:logger)   { Logger.new stdout }
  let(:path)     { File.expand_path("../migrate", __FILE__) }
  let(:gateway)  { ROM.env.gateways[:default] }
  let(:migrator) { gateway.migrator(logger: logger, path: path) }

  it "works" do
    ROM.setup(:cassandra, "127.0.0.1:9042")
    ROM.finalize

    expect { check "SELECT * FROM logs.users;" }.to raise_error StandardError
    expect { check "SELECT * FROM logs.logs" }.to raise_error StandardError
    expect(stdout.string).to be_empty

    migrator.apply target: "20150825142003"

    expect { check "SELECT * FROM logs.users;" }.not_to raise_error
    expect { check "SELECT * FROM logs.logs" }.to raise_error StandardError
    expect(stdout.string).to     include "The migration number '20150825142003' has been applied"
    expect(stdout.string).not_to include "The migration number '20150825142024' has been applied"

    migrator.apply

    expect { check "SELECT * FROM logs.users;" }.not_to raise_error
    expect { check "SELECT * FROM logs.logs" }.not_to raise_error
    expect(stdout.string).to     include "The migration number '20150825142024' has been applied"
    expect(stdout.string).not_to include "reversed"

    migrator.reverse

    expect { check "SELECT * FROM logs.users;" }.to raise_error StandardError
    expect { check "SELECT * FROM logs.logs" }.to raise_error StandardError
    expect(stdout.string).to include "The migration number '20150825142024' has been reversed"
    expect(stdout.string).to include "The migration number '20150825142003' has been reversed"
  end

  after { check "DROP KEYSPACE IF EXISTS rom;" }
  after { check "DROP KEYSPACE IF EXISTS logs;" }

end # describe migrator
