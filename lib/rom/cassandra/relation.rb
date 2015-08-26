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

    private

    def respond_to_missing?(name, *)
      dataset.respond_to? name
    end

    def method_missing(name, *args)
      Relation.new dataset.public_send(name, *args), source: source
    end

  end # class Relation

end # module ROM::Cassandra
