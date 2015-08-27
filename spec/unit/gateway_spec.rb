# encoding: utf-8

describe ROM::Cassandra::Gateway do

  let(:gateway) { described_class.new(uri) }
  let(:uri)     { { hosts: ["127.0.0.1"], port: 9042 } }

  describe ".new" do
    after { described_class.new("127.0.0.2", port: 9042) }

    let(:session_class) { ROM::Cassandra::Session }

    it "creates the session with uri" do
      allow(session_class).to receive(:new)
      expect(session_class).to receive(:new).with("127.0.0.2", port: 9042)
    end
  end # describe .new

  describe "#options" do
    subject { gateway.options }

    it "returns a uri" do
      expect(subject).to eql(uri)
    end
  end # describe #options

  describe "#session" do
    subject { gateway.session }

    it "is a session" do
      expect(subject).to be_instance_of ROM::Cassandra::Session
    end

    it "has a proper uri" do
      expect(subject.uri).to eql uri
    end
  end # describe #session

  describe "#[]" do
    subject { gateway["foo.bar"] }

    context "by default" do
      it { is_expected.to be_nil }
    end

    context "registered dataset" do
      before { gateway.dataset "foo.bar" }

      it { is_expected.to be_instance_of ROM::Cassandra::Dataset }
    end
  end # describe #[]

  describe "#dataset?" do
    subject { gateway.dataset? "foo.bar" }

    context "by default" do
      it { is_expected.to eql false }
    end

    context "registered dataset" do
      before { gateway.dataset "foo.bar" }

      it { is_expected.to eql true }
    end
  end # describe #dataset?

  describe "#dataset" do
    subject { gateway.dataset(name) }

    context "with valid name" do
      let(:name) { :"foo.bar" }

      it "registers the dataset for given table" do
        subject
        dataset = gateway["foo.bar"]

        expect(dataset.session).to eql(gateway.session)
        expect(dataset.keyspace).to eql :foo
        expect(dataset.table).to eql :bar
      end
    end

    context "with a string name" do
      let(:name) { "foo.bar" }

      it "registers the dataset for given table" do
        expect { subject }.to change { gateway[:"foo.bar"] }
      end
    end

    context "with invalid name" do
      let(:name) { "foo" }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of ArgumentError
          expect(error.message)
            .to eql "'foo' is not a valid full name of a table. " \
            "Use format 'keyspace.table' with both keyspace and table parts."
        end
      end
    end
  end # describe #dataset

  describe "#migrate" do
    let(:klass)    { ROM::Cassandra::Migrations::Migrator }
    let(:session)  { gateway.session }
    let(:migrator) { double :migrator, apply: nil }
    let(:path)     { double :path }
    let(:version)  { double :version }
    let(:logger)   { double :logger }

    before { allow(klass).to receive(:new) { migrator } }

    context "with options" do
      after { gateway.migrate path: path, version: version, logger: logger }

      it "initializes the migrator" do
        expect(klass).to receive(:new).with(session, path: path, logger: logger)
      end

      it "runs the migrator" do
        expect(migrator).to receive(:apply).with(version: version)
      end
    end

    context "without options" do
      after { gateway.migrate }

      it "initializes the migrator" do
        expect(klass).to receive(:new).with(session, {})
      end

      it "runs the migrator" do
        expect(migrator).to receive(:apply).with({})
      end
    end
  end # describe #migrate

end # describe ROM:Cassandra::Gateway
