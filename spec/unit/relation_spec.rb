# encoding: utf-8

describe ROM::Cassandra::Relation do

  let(:relation) { described_class.new source }
  let(:source)   { double :source, get: dataset }
  let(:dataset)  { double :dataset, foo: :updated_dataset }

  describe ".new" do
    subject { relation }

    it { is_expected.to be_kind_of ROM::Relation }
  end # describe .new

  describe "#source" do
    subject { relation.source }

    it "stores the source dataset" do
      expect(subject).to eql source
    end
  end # describe #source

  describe "#dataset" do
    subject { relation.dataset }

    it "applies #get to the source dataset" do
      expect(subject).to eql dataset
    end
  end # describe #dataset

  describe "#respond_to?" do
    context "method, defined for #dataset" do
      subject { relation.respond_to? :foo }

      it { is_expected.to eql true }
    end

    context "method, not defined for #dataset" do
      subject { relation.respond_to? :bar }

      it { is_expected.to eql false }
    end
  end # describe #all

  describe "#method_missing" do
    subject { relation.foo :bar }

    it "forwards call to #dataset" do
      expect(dataset).to receive(:foo).with(:bar)
      subject
    end

    it "returns a relation" do
      expect(subject).to be_kind_of described_class
    end

    it "updates a #dataset" do
      expect(subject.dataset).to eql :updated_dataset
    end

    it "preserves a #source" do
      expect(subject.source).to eql source
    end
  end # describe #all

end # describe ROM::Cassandra::Relation
