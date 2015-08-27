# encoding: utf-8

require "rom/cassandra/tasks"

describe "rake db:create_migration" do

  let(:generator) { ROM::Cassandra::Migrations::Generator }
  let(:task)      { Rake::Task["db:create_migration"] }

  before { allow(generator).to receive(:call) }
  before { $stdout = StringIO.new }

  context "without options" do
    subject { task.invoke }

    it "works" do
      expect(generator).not_to receive(:call)
      expect { subject }.to raise_error SystemExit
    end
  end

  context "with name" do
    after { task.invoke "add_foo" }

    it "works" do
      expect(generator).to receive(:call).with("add_foo", "db/migrate")
    end
  end

  context "with name and path" do
    after { task.invoke "add_foo", "custom" }

    it "works" do
      expect(generator).to receive(:call).with("add_foo", "custom")
    end
  end

  after { $stdout = STDOUT }
  after { task.reenable }

end # describe rake db:create_migration
