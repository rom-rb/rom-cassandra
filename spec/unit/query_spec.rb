# encoding: utf-8

describe ROM::Cassandra::Query do

  describe ".new" do
    subject { described_class.new.keyspace(:foo).table(:bar).select }

    it "encapsulates queries" do
      expect(subject).to be_kind_of described_class
    end

    it "builds queries" do
      expect(subject.to_s).to eql "SELECT * FROM foo.bar;"
    end

    it "responds to methods allowed by query" do
      expect(subject).to respond_to :select
      expect(subject).not_to respond_to :foo
    end
  end # describe .new

  describe ".batch" do
    subject { described_class.batch }

    it "returns lazy object" do
      expect(subject).to be_kind_of described_class
    end

    it "carries batch query" do
      expect(subject.add("foo").to_s).to eql "BEGIN BATCH foo APPLY BATCH;"
    end
  end # describe .batch

  describe ".keyspace" do
    subject { described_class.keyspace(:foo) }

    it "returns lazy object" do
      expect(subject).to be_kind_of described_class
    end

    it "carries keyspace query" do
      expect(subject.create.to_s).to eql "CREATE KEYSPACE foo;"
    end
  end # describe .keyspace

  describe ".table" do
    subject { described_class.table(:foo, :bar) }

    it "returns lazy object" do
      expect(subject).to be_kind_of described_class
    end

    it "carries keyspace query" do
      expect(subject.create.to_s).to eql "CREATE TABLE foo.bar ();"
    end
  end # describe .keyspace

end # describe ROM::Cassandra::Query
