# encoding: utf-8

require "fileutils"

shared_context :fake_migrate_folder do |folder|
  before { FileUtils.mkdir_p path }
  before { files.reverse_each(&FileUtils.method(:touch)) }

  let(:root) { File.expand_path "../../sandbox", __FILE__ }
  let(:path) { File.join(root, folder) }
  let(:files) do
    [
      "20151231235959_create_auth.rb",
      "20160101000000_create_users.rb",
      "20160101000001_create_logs.rb",
      "20160101000002_create_rights.rb"
    ].map { |name| File.join(path, name) }
  end

  after { FileUtils.rm_rf root }
end # shared context
