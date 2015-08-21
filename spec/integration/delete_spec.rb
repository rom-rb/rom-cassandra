# encoding: utf-8

require "shared/users"

module ROM::Cassandra::Test # the namespace for newly created classes

  describe "command 'delete'", :reset_cluster do

    include_context :users

    before do
      class DeleteUser < ROM::Commands::Delete[:cassandra]
        relation :users
        register_as :delete

        def execute(id)
          super { where(id: 1) }
        end
      end
    end

    subject { rom.command(:users).delete }

    it "works" do
      expect { subject.call(1) }
        .to change { select.by_id(1).to_a }
        .from([{ "id" => 1, "name" => "joe" }])
        .to []
    end

  end # describe command 'delete'

end # module ROM::Cassandra::Test
