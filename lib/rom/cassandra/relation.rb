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

    # Selects all records from the dataset
    #
    # @return [ROM::Cassandra::Dataset]
    #   The dataset with a query prepared for SELECT requests
    #
    def all
      dataset.get
    end

    private

    def respond_to_missing?(name, *)
      all.respond_to? name
    end

    def method_missing(*args)
      all.public_send(*args)
    end

  end # class Relation

end # module ROM::Cassandra
