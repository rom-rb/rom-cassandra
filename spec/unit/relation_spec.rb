# encoding: utf-8

describe ROM::Cassandra::Relation do

  let(:relation) { described_class.new dataset }
  let(:dataset)  { double :dataset, get: query }
  let(:query)    { double :query, foo: :foo }

  describe ".new" do
    subject { relation }

    it { is_expected.to be_kind_of ROM::Relation }
  end # describe .new

  describe "#all" do
    subject { relation.all }

    it "forwards to dataset#get" do
      expect(subject).to eql query
    end
  end # describe #all

  describe "#respond_to?" do
    context "method, defined for #all query" do
      subject { relation.respond_to? :foo }

      it { is_expected.to eql true }
    end

    context "method, not defined for #all query" do
      subject { relation.respond_to? :bar }

      it { is_expected.to eql false }
    end
  end # describe #all

  describe "#method_missing" do
    subject { relation.foo :bar }

    it "sends method to #all" do
      expect(query).to receive(:foo).with(:bar)
      subject
    end
  end # describe #all

end # describe ROM::Cassandra::Relation
