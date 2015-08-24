# encoding: utf-8

describe ROM::Cassandra::Migrations::Migration do

  let(:migration) { described_class.new session }
  let(:session)   { double :session, call: nil, freeze: nil }

  describe "#session" do
    subject { migration.session }

    it { is_expected.to eql session }
  end # describe #session

  describe "#up" do
    subject { migration.up }

    it { is_expected.to be_nil }
  end # describe #up

  describe "#down" do
    subject { migration.down }

    it { is_expected.to be_nil }
  end # describe #down

  describe "#call" do
    subject { migration.call query }
    let(:query) { double :query, to_s: :foo }

    it "is delegated to #session" do
      expect(session).to receive(:call).with(:foo)
      subject
    end
  end # describe #call

  describe "#keyspace" do
    subject { migration.keyspace(:foo) }

    it "starts building query" do
      query = subject.create.if_not_exists.to_s

      expect(query).to eql "CREATE KEYSPACE IF NOT EXISTS foo;"
    end
  end # describe #keyspace

  describe ".inherited" do
    subject { Class.new described_class }

    it "hides helpers" do
      expect(subject.private_instance_methods)
        .to include(:call, :keyspace, :up, :down)
    end

    it "keeps parent class' helpers unchanged" do
      expect { subject }.not_to change { described_class.new(session).methods }
    end
  end # describe .inherited

end # describe ROM::Cassandra::Migrations::Migration
