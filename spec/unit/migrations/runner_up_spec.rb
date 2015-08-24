# encoding: utf-8

describe ROM::Cassandra::Migrations::RunnerUp do

  let(:klass)   { Class.new described_class }
  let(:runner)  { klass.new session, logger, path }
  let(:session) { double :session, call: nil }
  let(:logger)  { double :logger, info: nil }
  let(:path)    { "foo/20150824103059_add_foo.rb" }

  before do
    klass.send(:define_method, :require) do |_|
      AddFoo = Class.new(ROM::Cassandra::Migrations::Migration)
    end
    klass.send(:define_method, :select_version) { [] }
  end

  describe "#migrate?" do
    subject { runner.migrate? }

    context "when select_version isn't empty" do
      before do
        klass.send(:define_method, :select_version) { [{ id: 20150824103059 }] }
      end

      it { is_expected.to eql false }
    end

    context "when select_version is empty" do
      it { is_expected.to eql true }
    end
  end # describe #migrate?

  describe "#apply" do
    after  { runner.apply }
    before { allow(runner).to receive(:migration) { migration } }

    let(:migration) { double :migration, up: nil }

    it "rolls back migration" do
      expect(migration).to receive(:up).once
    end
  end # describe #apply

  describe "#register" do
    after { runner.register }

    it "sends the DELETE query to session" do
      expect(session)
        .to receive(:call)
        .with "INSERT INTO rom.migrations (version) VALUES ('20150824103059');"
    end
  end # describe #register

  describe "#log" do
    after { runner.log }

    it "logs the message" do
      expect(logger)
        .to receive(:info)
        .with "Apply migration 20150824103059\n"
    end
  end # describe #log

  after { Object.send :remove_const, :AddFoo if Object.const_defined? :AddFoo }

end # describe ROM::Cassandra::Migrations::RunnerUp
