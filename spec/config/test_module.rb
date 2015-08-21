# encoding: utf-8

# Recreates ROM::Cassandra::Test before every spec
RSpec.configure do |config|
  config.before { module ROM::Cassandra::Test; end }
  config.after  { ROM::Cassandra.send :remove_const, :Test }
end
