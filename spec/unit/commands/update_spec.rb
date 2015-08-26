# encoding: utf-8

describe ROM::Cassandra::Commands::Update do

  let(:command)  { described_class.new relation }
  let(:relation) { double :relation, source: dataset }
  let(:dataset)  { double :dataset, update: update }
  let(:update)   { double :update }

  describe ".new" do
    subject { command }

    it { is_expected.to be_kind_of ROM::Commands::Update }
    it { is_expected.to be_kind_of ROM::Cassandra::Commands::Executor }
  end # describe .new

  describe "#query" do
    subject { command.query }

    it "restricts dataset by UPDATE statements" do
      expect(subject).to eql update
    end
  end # describe #query

end # describe ROM::Cassandra::Commands::Update
