# encoding: utf-8

module ROM::Cassandra

  # Relation subclass of Cassandra adapter
  #
  # @example
  #   class Users < ROM::Relation[:cassandra]
  #     def last_ten_admins
  #       select(:id, :name)
  #         .where(role: "admin")
  #         .using(consistency: :quorum)
  #         .order(:name, :desc)
  #         .limit(10)
  #     end
  #   end
  #
  # @api public
  #
  class Relation < ROM::Relation

    adapter :cassandra
    option  :source

    # @!attribute [r] source
    #
    # @return [ROM::Cassandra::Dataset]
    #   The source dataset before `get` method has been applied
    #
    attr_reader :source

    # @private
    def initialize(*)
      super
      return if (@source = options[:source])
      @source  = dataset
      @dataset = dataset.get
    end

    # Returns the relation whose source is restricted by `#insert` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def insert_query
      reload source.insert
    end

    # Returns the relation whose source is restricted by `#update` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def update_query
      reload source.update
    end

    # Returns the relation whose source is restricted by `#delete` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def delete_query
      reload source.delete
    end

    # Returns the relation whose source is restricted by `#delete` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def batch_query
      reload source.batch
    end

    private

    def respond_to_missing?(name, *)
      dataset.respond_to? name
    end

    def method_missing(name, *args)
      reload dataset.public_send(name, *args)
    end

    def reload(dataset)
      Relation.new dataset, source: source
    end

  end # class Relation

end # module ROM::Cassandra
