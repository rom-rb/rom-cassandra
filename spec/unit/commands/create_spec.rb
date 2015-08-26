# encoding: utf-8

describe ROM::Cassandra::Commands::Create do

  let(:command)  { described_class.new relation }
  let(:relation) { double :relation, insert_query: insert }
  let(:insert)   { double :insert, foo: :updated_relation }

  describe ".new" do
    subject { command }

    it { is_expected.to be_kind_of ROM::Commands::Create }
  end # describe .new

  describe "#relation" do
    subject { command.relation }

    it "restricts dataset by INSERT statements" do
      expect(subject).to eql insert
    end
  end # describe #relation

  describe "#method_missing" do
    subject { command.foo :bar }

    it "returns a command" do
      expect(subject).to be_kind_of described_class
    end

    it "updates the relation" do
      expect(insert).to receive(:foo).with(:bar)
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

end # describe ROM::Cassandra::Commands::Create
