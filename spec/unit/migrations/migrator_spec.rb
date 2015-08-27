# encoding: utf-8

require "shared/fake_migrate_folder"

describe ROM::Cassandra::Migrations::Migrator do

  include_context :fake_migrate_folder, "context"

  let(:migrator) { described_class.new session, logger: logger, path: path }
  let(:logger)   { double :logger }
  let(:session)  { double :session, call: nil }

  describe "#session" do
    subject { migrator.session }

    it "returns the session by uri" do
      expect(subject).to eql(session)
    end
  end # describe #session

  describe "#logger" do
    subject { migrator.logger }

    context "when logger is specified" do
      it { is_expected.to eql logger }
    end

    context "when logger isn't specified" do
      let(:migrator) { described_class.new session }

      it { is_expected.to be_kind_of ROM::Cassandra::Migrations::Logger }
    end
  end # describe #logger

  describe "#root" do
    subject { migrator.root }

    context "when path is specified" do
      it { is_expected.to eql path }
    end

    context "when path isn't specified" do
      let(:migrator) { described_class.new session }

      it { is_expected.to eql("db/migrate") }
    end
  end # describe #root

  describe "#paths" do
    subject { migrator.paths }

    it "returns the ordered list of migrations" do
      expect(subject).to eql(files)
    end
  end # describe #paths

  describe "#apply" do
    before { allow(ROM::Cassandra::Migrations::Runner).to receive(:apply) }

    let(:runner_up)   { ROM::Cassandra::Migrations::RunnerUp }
    let(:runner_down) { ROM::Cassandra::Migrations::RunnerDown }

    context "without a version" do
      after { migrator.apply }

      it "applies all migrations in direct order" do
        files.each do |path|
          expect(runner_up)
            .to receive(:apply)
            .with(session, logger, path)
            .ordered
        end
      end

      it "doesn't rollback migrations" do
        expect(runner_down).not_to receive(:apply)
      end
    end

    context "with the zero version" do
      after { migrator.apply version: 0 }

      it "rolls back all migrations in reverse order" do
        files.reverse_each do |path|
          expect(runner_down)
            .to receive(:apply)
            .with(session, logger, path)
            .ordered
        end
      end

      it "doesn't apply migrations" do
        expect(runner_up).not_to receive(:apply)
      end
    end

    context "with a non-zero version" do
      after { migrator.apply version: 20160101000000 }

      it "applies migrations up to the version in direct order" do
        files[0..1].each do |path|
          expect(runner_up)
            .to receive(:apply)
            .with(session, logger, path)
            .ordered
        end
      end

      it "rolls back migrations with greater versions in reverse order" do
        files[2..-1].reverse_each do |path|
          expect(runner_down)
            .to receive(:apply)
            .with(session, logger, path)
            .ordered
        end
      end
    end
  end # describe #apply

end # describe ROM::Cassandra::Migrations::Migrator
