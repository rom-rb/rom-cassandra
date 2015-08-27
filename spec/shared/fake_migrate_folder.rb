# encoding: utf-8

require "fakefs/spec_helpers"
require "fileutils"

shared_context :fake_migrate_folder do |folder|
  include FakeFS::SpecHelpers

  before { FileUtils.mkdir folder }
  before { files.shuffle.each(&FileUtils.method(:touch)) }

  let(:path) { folder }
  let(:files) do
    [
      "/#{folder}/20151231235959_create_auth.rb",
      "/#{folder}/20160101000000_create_users.rb",
      "/#{folder}/20160101000001_create_logs.rb",
      "/#{folder}/20160101000002_create_rights.rb"
    ]
  end
end # shared context
