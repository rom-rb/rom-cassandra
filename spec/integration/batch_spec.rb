# encoding: utf-8

require "shared/users"

module ROM::Cassandra::Test # the namespace for newly created classes

  describe "command 'batch'", :reset_cluster do

    include_context :users

    before do
      class Batch < ROM::Cassandra::Commands::Batch
        relation :users
        register_as :batch

        def execute
          super(
            keyspace(:auth).table(:users).delete.where(id: 1),
            keyspace(:auth).table(:users).insert(id: 3, name: "frank")
          )
        end
      end
    end

    subject { rom.command(:users).batch }

    it "works" do
      expect { subject.call }
        .to change { select.to_a }
        .from([{ "id" => 1, "name" => "joe" }, { "id" => 2, "name" => "jane" }])
        .to [{ "id" => 2, "name" => "jane" }, { "id" => 3, "name" => "frank" }]
    end

  end # describe command 'batch'

end # module ROM::Cassandra::Commands::Batch
