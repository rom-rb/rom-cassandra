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

    include Immutability # defines __update__

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
      @source  = dataset     # stores the source dataset
      @dataset = dataset.get # allows sending get requests only
    end

    # Returns the relation whose source is restricted by `#insert` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def insert_query
      __update__ { @dataset = source.insert }
    end

    # Returns the relation whose source is restricted by `#update` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def update_query
      __update__ { @dataset = source.update }
    end

    # Returns the relation whose source is restricted by `#delete` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def delete_query
      __update__ { @dataset = source.delete }
    end

    # Returns the relation whose source is restricted by `#delete` lazy query
    #
    # @return [ROM::Cassandra::Relation]
    #
    def batch_query
      __update__ { @dataset = source.batch }
    end

    private

    # Sends all other methods to dataset, restricted by #get queries,
    # and returns new relation carrying updated dataset
    #
    def method_missing(*args)
      __update__ { @dataset = dataset.public_send(*args) }
    end

    def respond_to_missing?(name, *)
      dataset.respond_to? name
    end

  end # class Relation

end # module ROM::Cassandra
