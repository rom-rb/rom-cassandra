# encoding: utf-8

require "shared/users"

module ROM::Cassandra::Test # the namespace for newly created classes

  describe "relation" do

    include_context :users

    let(:subject) { rom.relation(:users) }

    it "works" do
      expect(subject.all.to_a).to eql [
        { "id" => 1, "name" => "joe" },
        { "id" => 2, "name" => "jane" }
      ]
    end

    it "works with modifiers" do
      expect(subject.by_id(1).to_a)
        .to eql [{ "id" => 1, "name" => "joe" }]
    end

  end # describe relation

end # module ROM::Cassandra::Test
