# encoding: utf-8

describe ROM::Cassandra::Commands::Create do

  let(:command)  { described_class.new relation }
  let(:relation) { double :relation, source: dataset }
  let(:dataset)  { double :dataset, insert: insert }
  let(:insert)   { double :insert }

  describe ".new" do
    subject { command }

    it { is_expected.to be_kind_of ROM::Commands::Create }
    it { is_expected.to be_kind_of ROM::Cassandra::Commands::Executor }
  end # describe .new

  describe "#query" do
    subject { command.query }

    it "restricts dataset by INSERT statements" do
      expect(subject).to eql insert
    end
  end # describe #query

end # describe ROM::Cassandra::Commands::Create
