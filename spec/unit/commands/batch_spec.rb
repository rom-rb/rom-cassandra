# encoding: utf-8

describe ROM::Cassandra::Commands::Batch do

  let(:command)  { described_class.new relation }
  let(:relation) { double :relation, batch_query: batch }
  let(:batch)    { double :batch, foo: :updated_relation }

  describe ".new" do
    subject { command }

    it { is_expected.to be_kind_of ROM::Command }
  end # describe .new

  describe "#relation" do
    subject { command.relation }

    it "restricts dataset by UPDATE statements" do
      expect(subject).to eql batch
    end
  end # describe #relation

  describe "#method_missing" do
    subject { command.foo :bar }

    it "returns a command" do
      expect(subject).to be_kind_of described_class
    end

    it "updates the relation" do
      expect(batch).to receive(:foo).with(:bar)
      expect(subject.relation).to eql :updated_relation
    end
  end # describe #method_missing

  describe "#respond_to_missing?" do
    subject { command.respond_to? name }

    context "method of #relation" do
      let(:name) { :foo }

      it { is_expected.to eql true }
    end

    context "method not defined for #relation" do
      let(:name) { :bar }

      it { is_expected.to eql false }
    end
  end # describe #respond_to_missing?

  describe "#execute" do
    let(:updated) { double :updated, to_a: result }
    let(:result)  { double :result }

    context "without argument" do
      subject { command.execute }

      it "applies #to_a" do
        allow(command).to receive(:to_a) { result }

        expect(subject).to eql(result)
      end
    end

    context "with argument" do
      subject { command.execute(updated) }

      it "updates and finalizes the command" do
        expect(updated).to receive(:to_a)
        expect(subject).to eql(result)
      end
    end
  end # describe #execute

  describe "#keyspace" do
    subject { command.keyspace(:foo) }

    it "returns query" do
      expect(subject).to be_kind_of ROM::Cassandra::Query
      expect(subject.use.to_s).to eql "USE foo;"
    end
  end # describe #keyspace

end # describe ROM::Cassandra::Commands::Batch
