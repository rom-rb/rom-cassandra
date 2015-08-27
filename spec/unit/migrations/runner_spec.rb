# encoding: utf-8

describe ROM::Cassandra::Migrations::Runner do

  let(:klass)   { Class.new described_class }
  let(:runner)  { klass.new session, logger, path }
  let(:session) { double :session, call: nil }
  let(:logger)  { double :logger }
  let(:path)    { "foo/20150824103059_add_foo.rb" }

  before do
    klass.send(:define_method, :migrate?) { true }
    klass.send(:define_method, :require) do |name|
      AddFoo = Class.new(ROM::Cassandra::Migrations::Migration) if name == path
      true
    end
  end

  describe "#session" do
    subject { runner.session }

    it { is_expected.to eql session }
  end # describe #session

  describe "#logger" do
    subject { runner.logger }

    it { is_expected.to eql logger }
  end # describe #logger

  describe "#path" do
    subject { runner.path }

    it { is_expected.to eql path }
  end # describe #path

  describe "#version" do
    subject { runner.version }

    context "from valid timestamp" do
      let(:path) { "foo/12345678901234/20150824103059_add_foo.rb" }

      it { is_expected.to eql 20150824103059 }
    end

    context "from invalid timestamp" do
      let(:path) { "foo/2015082410305_add_foo.rb" }

      it "fails" do
        expect { subject }.to raise_error do |error|
          expect(error).to be_kind_of NameError
          expect(error.message)
            .to eql("invalid version number: 'foo/2015082410305_add_foo.rb'")
        end
      end
    end
  end # describe #version

  describe "#migration" do
    subject { runner.migration }

    it "creates migration for #session" do
      expect(subject).to be_kind_of(AddFoo)
      expect(subject.session).to eql(session)
    end

    context "when #migrate? is falsey" do
      before { klass.send(:define_method, :migrate?) { nil } }

      it { is_expected.to eql nil }
    end
  end # describe #migration

  describe "#clear" do
    subject { runner.clear }

    before { runner }
  end # describe #clear

  describe "#call" do
    before do
      allow(runner).to receive(:apply)
      allow(runner).to receive(:register)
      allow(runner).to receive(:log)
    end

    subject { runner.call }

    it "calls commands in the right order" do
      expect(runner).to receive(:apply).ordered
      expect(runner).to receive(:register).ordered
      expect(runner).to receive(:log).ordered
      subject
    end

    context "when #migration isn't set" do
      before { allow(runner).to receive(:migration) }

      it "skips all commands" do
        expect(runner).not_to receive(:apply)
        expect(runner).not_to receive(:register)
        expect(runner).not_to receive(:log)
        subject
      end
    end
  end # describe #call

  describe "#select_version" do
    after { runner.select_version }

    let(:queries) do
      [
        "CREATE KEYSPACE IF NOT EXISTS rom WITH REPLICATION =" \
          " {'class': 'SimpleStrategy', 'replication_factor': 3};",
        "CREATE TABLE IF NOT EXISTS rom.migrations " \
          "(version text, PRIMARY KEY (version));",
        "SELECT * FROM rom.migrations WHERE version = '20150824103059';"
      ]
    end

    it "sends requests to Cassandra cluster" do
      queries.each do |query|
        expect(session).to receive(:call).with(query).ordered
      end
    end
  end # describe #select_version

  describe ".apply" do
    let(:runner) { double :runner, call: nil }

    before { allow(described_class).to receive(:new) { runner } }
    after  { described_class.apply(session, logger, path) }

    it "creates and calls the runner" do
      expect(described_class).to receive(:new).with(session, logger, path)
      expect(runner).to receive(:call)
    end
  end # describe .apply

  after { Object.send :remove_const, :AddFoo if Object.const_defined? :AddFoo }

end # describe ROM::Cassandra::Migrations::Runner
