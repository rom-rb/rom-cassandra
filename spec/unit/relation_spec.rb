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

  describe "#insert_query" do
    subject { relation.insert_query }

    before { allow(source).to receive(:insert) { insert } }
    let(:insert) { double :insert }

    it "returns a relation" do
      expect(subject).to be_kind_of described_class
    end

    it "preserves #source" do
      expect(subject.source).to eql source
    end

    it "sets source.insert as a dataset" do
      expect(subject.dataset).to eql insert
    end
  end # describe #insert_query

  describe "#update_query" do
    subject { relation.update_query }

    before { allow(source).to receive(:update) { update } }
    let(:update) { double :update }

    it "returns a relation" do
      expect(subject).to be_kind_of described_class
    end

    it "preserves #source" do
      expect(subject.source).to eql source
    end

    it "sets source.update as a dataset" do
      expect(subject.dataset).to eql update
    end
  end # describe #update_query

  describe "#delete_query" do
    subject { relation.delete_query }

    before { allow(source).to receive(:delete) { delete } }
    let(:delete) { double :delete }

    it "returns a relation" do
      expect(subject).to be_kind_of described_class
    end

    it "preserves #source" do
      expect(subject.source).to eql source
    end

    it "sets source.delete as a dataset" do
      expect(subject.dataset).to eql delete
    end
  end # describe #delete_query

  describe "#batch_query" do
    subject { relation.batch_query }

    before { allow(source).to receive(:batch) { batch } }
    let(:batch) { double :batch }

    it "returns a relation" do
      expect(subject).to be_kind_of described_class
    end

    it "preserves #source" do
      expect(subject.source).to eql source
    end

    it "sets source.batch as a dataset" do
      expect(subject.dataset).to eql batch
    end
  end # describe #batch_query

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

    it "preserves #source" do
      expect(subject.source).to eql source
    end

    it "updates dataset" do
      expect(subject.dataset).to eql :updated_dataset
    end
  end # describe #all

end # describe ROM::Cassandra::Relation
