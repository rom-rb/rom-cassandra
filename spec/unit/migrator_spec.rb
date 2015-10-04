# encoding: utf-8

describe ROM::Cassandra::Migrator do
  let(:migrator) { described_class.new gateway }
  let(:gateway)  { double :gateway, call: [{ "version" => "foo1" }] }

  describe ".new" do
    subject { migrator }

    it "prepares keyspace" do
      expect(gateway)
        .to receive(:call)
        .with("CREATE KEYSPACE IF NOT EXISTS rom WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 3};")
        .ordered
      expect(gateway)
        .to receive(:call)
        .with("CREATE TABLE IF NOT EXISTS rom.migrations (version text, PRIMARY KEY (version));")
        .ordered
      subject
    end

    it { is_expected.to be_kind_of ROM::Migrator }
  end # describe .new

  describe "#call" do
    subject { migrator.call(:foo) }

    it "forwards to gateway" do
      expect(gateway).to receive(:call).with(:foo)
      expect(subject).to eql gateway.call
    end
  end # describe #call

  describe "#register" do
    subject { migrator.register("bar") }

    it "sends query to gateway" do
      expect(gateway)
        .to receive(:call)
        .with "INSERT INTO rom.migrations (version) VALUES ('bar');"
      subject
    end
  end # describe #register

  describe "#unregister" do
    subject { migrator.unregister("bar") }

    it "sends query to gateway" do
      expect(gateway)
        .to receive(:call)
        .with "DELETE FROM rom.migrations WHERE version = 'bar';"
      subject
    end
  end # describe #unregister

  describe "#registered" do
    subject { migrator.registered }

    it "selects from gateway" do
      expect(gateway)
        .to receive(:call)
        .with "SELECT version FROM rom.migrations;"
      expect(subject).to eql ["foo1"]
    end
  end # describe #registered

  describe "#keyspace" do
    subject { migrator.keyspace(:foo) }

    it "returns a CQL query builder" do
      cql = subject.create.if_not_exists.to_s

      expect(subject).to be_kind_of ROM::Cassandra::Query
      expect(cql).to eql "CREATE KEYSPACE IF NOT EXISTS foo;"
    end
  end # describe #keyspace

end # describe ROM::Cassandra::Migrator
