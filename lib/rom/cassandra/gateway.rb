# encoding: utf-8

module ROM::Cassandra

  # The gateway to the keyspace of the Cassandra cluster
  #
  # @api public
  #
  class Gateway < ROM::Gateway

    include Equalizer.new(:options, :datasets)

    adapter :cassandra

    # @!attribute [r] connection
    #
    # @return [ROM::Cassandra::Connection] The current connection
    #
    attr_reader :connection

    # @!attribute [r] datasets
    #
    # @return [Hash] The list of registered datasets
    #
    attr_reader :datasets

    # Initializes the ROM gateway to the Cassandra cluster
    #
    # @example
    #   ROM::Cassandra::Gateway.new(
    #     hosts:    ["10.0.1.1", "10.0.1.2"],
    #     port:     9042,
    #     username: "admin",
    #     password: "foo"
    #   )
    #
    # @example
    #   ROM::Cassandra::Gateway.new(
    #     "http://10.0.1.1:9042",
    #     username: "admin",
    #     password: "foo"
    #   )
    #
    # @param [Hash] options
    #
    def initialize(*options)
      @connection  = Connection.new(*options)
      @datasets = {}
    end

    # The options of the initialized connection
    #
    # @return [Hash]
    #
    def options
      connection.uri
    end

    # Registers a new dataset
    #
    # @example
    #   dataset "foo.bar"
    #
    # @param [#to_sym] name The full name of the table
    #
    # @return [ROM::Cassandra::Dataset]
    #
    def dataset(name)
      @datasets[name.to_sym] = Dataset.new(self, *split(name))
    end

    # Returns the registered dataset
    #
    # @param (see #dataset)
    #
    # @return (see #dataset)
    #
    def [](name)
      datasets[name.to_sym]
    end

    # Checks whether the dataset is registered
    #
    # @param (see #dataset)
    #
    # @return [Boolean]
    #
    def dataset?(name)
      self[name] ? true : false
    end

    # Sends CQL query to the current connection
    #
    # @param [String] cql
    #
    # @return [undefined]
    #
    def call(cql)
      connection.call cql
    end

    private

    def split(name)
      list = name.to_s.split(".")
      return list if 2.equal? list.count
      fail ArgumentError.new "'#{name}' is not a valid full name of a table. " \
        "Use format 'keyspace.table' with both keyspace and table parts."
    end

  end # class Gateway

end # module ROM::Cassandra
