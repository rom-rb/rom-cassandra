# encoding: utf-8

module ROM::Cassandra

  module Migrations

    # Generates the migration with given name at the target folder
    #
    # @example
    #   ROM::Cassandra::Migrations::Generator.call "create_users", "/db/migrate"
    #   # => "/db/migrate/20150827133303_create_users.rb"
    #
    class Generator

      # Initializes and calls the generator at once
      #
      # @param (see #initialize)
      #
      # @return (see #call)
      #
      def self.call(name, path)
        new(name, path).call
      end

      # Initializes the generator with path to target folder and migration name
      #
      # @param [String] path
      # @param [String] name
      #
      def initialize(name, path)
        @path    = path
        @name    = Inflecto.underscore(name)
        @klass   = Inflecto.camelize(name)
        @version = Time.new.strftime "%Y%m%d%H%M%S"
      end

      # Generates the migration
      #
      # @return [String] the full path to the migration
      #
      def call
        FileUtils.mkdir_p path
        File.write target, content

        target
      end

      private

      attr_reader :name, :path, :version

      def content
        ERB.new(File.read source).result(binding)
      end

      def source
        File.expand_path("../generator/migration.erb", __FILE__)
      end

      def target
        File.join(path, "#{version}_#{name}.rb")
      end

    end # class Generator

  end # module Migrations

end # module ROM::Cassandra
