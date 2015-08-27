# encoding: utf-8

namespace :db do
  desc "Create a migration (required parameter: NAME)"
  task :create_migration, [:name, :path] do |_, args|
    unless (name = args[:name])
      puts "No NAME specified.\n" \
        "Usage example: `rake db:create_migration[create_users]`"
      exit
    end
    path = args[:path] || "db/migrate"

    result = ROM::Cassandra::Migrations::Generator.call(name, path)
    puts "<= Created #{result}"
  end
end
