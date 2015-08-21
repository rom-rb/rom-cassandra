# encoding: utf-8

require "shared/users"

module ROM::Cassandra::Test # the namespace for newly created classes

  describe "command 'update'", :reset_cluster do

    include_context :users

    before do
      class UpdateUser < ROM::Commands::Update[:cassandra]
        relation :users
        register_as :update

        def execute(id, name)
          super { update(name: name).where(id: 1) }
        end
      end
    end

    subject { rom.command(:users).update }

    it "works" do
      expect { subject.call(1, "frank") }
        .to change { select.by_id(1).to_a }
        .from([{ "id" => 1, "name" => "joe" }])
        .to [{ "id" => 1, "name" => "frank" }]
    end

  end # describe command 'update'

end # module ROM::Cassandra::Test
