# encoding: utf-8

require "shared/users"

module ROM::Cassandra::Test # the namespace for newly created classes

  describe "command 'create'", :reset_cluster do

    include_context :users

    before do
      class CreateUser < ROM::Commands::Create[:cassandra]
        relation :users
        register_as :create

        def execute(id, name)
          super { insert(id: id, name: name) }
        end
      end
    end

    subject { rom.command(:users).create }

    it "works" do
      expect { subject.call(3, "jill") }
        .to change { select.by_id(3).to_a }
        .from([])
        .to [{ "id" => 3, "name" => "jill" }]
    end

  end # describe command 'create'

end # module ROM::Cassandra::Test
