# encoding: utf-8

describe ROM::Cassandra::Dataset do

  let(:dataset)  { described_class.new(gateway, keyspace, table) }
  let(:gateway)  { double :gateway }
  let(:keyspace) { "foo" }
  let(:table)    { "bar" }

  describe "#gateway" do
    subject { dataset.gateway }

    it { is_expected.to eql gateway }
  end # describe #gateway

  describe "#keyspace" do
    subject { dataset.keyspace }

    it { is_expected.to eql :foo }
  end # describe #keyspace

  describe "#table" do
    subject { dataset.table }

    it { is_expected.to eql :bar }
  end # describe #table

  describe "#query" do
    subject { dataset.query }

    it "returns a lazy query restricted by #table" do
      expect(subject.select.to_s).to eql "SELECT * FROM foo.bar;"
    end
  end # describe #query

  describe "#get" do
    subject { dataset.get(:bar, :baz) }

    let(:query) { double :query, select: double }
    before { dataset.send :instance_variable_set, :@query, query }

    it "forwards calls to the #query" do
      expect(query).to receive(:select).with(:bar, :baz)
      subject
    end

    it "returns the dataset with updated query" do
      expect(subject).to be_kind_of described_class
      expect(subject.query).to eql query.select
    end
  end # describe #get

  describe "#batch" do
    subject { dataset.batch }

    let(:batch) { double :batch }
    before { allow(ROM::Cassandra::Query).to receive(:batch) { batch } }

    it "returns the dataset with updated query" do
      expect(subject.query).to eql batch
    end
  end # describe #batch

  describe "#each" do
    let(:result) { [:foo, :bar] }
    before { allow(gateway).to receive(:call) { result } }

    context "with a block" do
      subject { dataset.map { |item| item } }

      it "sends #query to #gateway and iterates through the result" do
        expect(gateway).to receive(:call).with(dataset.query)
        expect(subject).to eql result
      end
    end

    context "without a block" do
      subject { dataset.each }

      it "sends #query to #gateway and returns result's enumerator" do
        expect(subject).to be_kind_of Enumerator
        expect(subject.to_a).to eql result
      end
    end
  end # describe #each

  describe "#respond_to?" do
    subject { dataset.respond_to? :foo }

    context "method defined for #query" do
      before { allow(dataset.query).to receive(:foo) }

      it { is_expected.to eql true }
    end

    context "method missing for #query" do
      it { is_expected.to eql false }
    end
  end # describe #respond_to?

  describe "#method_missing" do
    subject { dataset.foo(:bar) }

    let(:updated_query) { double :updated_query }
    before { allow(dataset.query).to receive(:foo) { updated_query } }

    it "forwards calls to the #query" do
      expect(dataset.query).to receive(:foo).with(:bar)
      subject
    end

    it "returns the dataset with updated query" do
      expect(subject.query).to eql updated_query
    end
  end # describe #method_missing

end # describe ROM::Cassandra::Dataset
