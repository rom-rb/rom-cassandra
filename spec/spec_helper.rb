# encoding: utf-8

begin
  require "hexx-suit"
  Hexx::Suit.load_metrics_for(self)
rescue LoadError
  require "hexx-rspec"
  Hexx::RSpec.load_metrics_for(self)
end

# Loads the code under test
require "rom-cassandra"

# Configures RSpec
require "config/reset_cluster"
require "config/rom"
require "config/test_module"
