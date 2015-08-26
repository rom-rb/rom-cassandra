# encoding: utf-8

describe ROM::Cassandra::Commands::Delete do

  let(:command)  { described_class.new relation }
  let(:relation) { double :relation, source: dataset }
  let(:dataset)  { double :dataset, delete: delete }
  let(:delete)   { double :delete }

  describe ".new" do
    subject { command }

    it { is_expected.to be_kind_of ROM::Commands::Delete }
    it { is_expected.to be_kind_of ROM::Cassandra::Commands::Executor }
  end # describe .new

  describe "#query" do
    subject { command.query }

    it "restricts dataset by DELETE statements" do
      expect(subject).to eql delete
    end
  end # describe #query

end # describe ROM::Cassandra::Commands::Delete
