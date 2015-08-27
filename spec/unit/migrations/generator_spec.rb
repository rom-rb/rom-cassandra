# encoding: utf-8

require "shared/fake_migrate_folder"
require "timecop"

describe ROM::Cassandra::Migrations::Generator do

  include_context :fake_migrate_folder, "context"

  let(:name)    { "createFoo" }
  let(:time)    { Time.utc(2017, "dec", 31, 23, 59, 59) }
  let(:target)  { "#{path}/db/20171231235959_create_foo.rb" }
  let(:content) { File.read(target) }

  describe ".call" do
    subject { described_class.call(name, "#{path}/db") }

    before { Timecop.freeze(time) }
    after  { Timecop.return }

    it "creates the migration" do
      subject
      expect(content).to include "CreateFoo"
    end

    it "returns the name of the migration" do
      expect(subject).to eql(target)
    end
  end # describe .call

end # describe ROM::Cassandra::Migrations::Generator
