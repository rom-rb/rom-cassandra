# encoding: utf-8

describe ROM::Cassandra::Query do

  let(:builder) { described_class.new }
  subject { builder.keyspace(:foo).table(:bar).select }

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

end # describe ROM::Cassandra::Query
