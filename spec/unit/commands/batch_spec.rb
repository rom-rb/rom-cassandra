# encoding: utf-8

describe ROM::Cassandra::Commands::Batch do

  let(:command)  { described_class.new relation }
  let(:relation) { double :relation, source: dataset }
  let(:dataset)  { double :dataset, batch: query, keyspace: keyspace }
  let(:query)    { double :query, add: nil }
  let(:keyspace) { :foo }

  describe ".new" do
    subject { command }

    it { is_expected.to be_kind_of ROM::Command }
  end # describe .new

  describe "#dataset" do
    subject { command.dataset }

    it "returns the source of the #relation" do
      expect(subject).to eql dataset
    end
  end # describe #dataset

  describe "#query" do
    subject { command.query }

    it "returns the batch query of the #dataset" do
      expect(subject).to eql query
    end
  end # describe #query

  describe "#keyspace" do
    subject { command.keyspace(:foo).table(:bar).select.to_s }

    it "returns the keyspace query" do
      expect(subject).to eql "SELECT * FROM foo.bar;"
    end
  end # describe #query

  describe "#execute" do
    subject(:execute) { command.execute(:foo, :bar) }

    it "updates and executes the query" do
      result = double
      bar = double(:bar, to_a: result)
      foo = double(:foo, add: bar)
      allow(query).to receive(:add) { foo }

      expect(query).to receive(:add).with(:foo)
      expect(foo).to receive(:add).with(:bar)
      expect(subject).to eql result
    end
  end # describe #execute

end # describe ROM::Cassandra::Commands::Create
