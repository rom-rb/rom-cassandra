# encoding: utf-8

module ROM::Cassandra

  # The module provides #__update__ method that returns
  # dup of the current instance, updated from within a block.
  #
  # In lieu of 'immutability' gem, the method doesn't freeze instances,
  # because they can carry <potentially> stateful 'poseidon' connection.
  #
  # @api private
  #
  # @author nepalez <andrew.kozin@gmail.com>
  #
  module Immutability

    private

    def __update__(&block)
      dup.tap { |instance| instance.instance_eval(&block) }
    end

  end # module Immutability

end # module ROM::Cassandra
