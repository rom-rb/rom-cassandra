# encoding: utf-8

module ROM::Cassandra

  # The gateway to the keyspace of the Cassandra cluster
  #
  # @api public
  #
  class Gateway < ROM::Gateway

    include Equalizer.new(:options, :datasets)

    # @!attribute [r] options
    #
    # @return [Hash] The options of the session
    #
    attr_reader :options

    # @!attribute [r] session
    #
    # @return [ROM::Cassandra::Session] The current session
    #
    attr_reader :session

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
    # @param [Hash] options
    #
    def initialize(options)
      @options  = options
      @session  = Session.new(options)
      @datasets = {}
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
      @datasets[name.to_sym] = Dataset.new(session, *split(name))
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

    private

    def split(name)
      list = name.to_s.split(".")
      return list if 2.equal? list.count
      fail ArgumentError.new "'#{name}' is not a valid full name of a table. " \
        "Use format 'keyspace.table' with both keyspace and table parts."
    end

  end # class Gateway

end # module ROM::Cassandra
