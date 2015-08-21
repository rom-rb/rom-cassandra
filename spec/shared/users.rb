# encoding: utf-8

shared_examples :users do

  let(:setup)   { ROM.setup(:cassandra, hosts: ["127.0.0.1"], port: 9042) }
  let(:gateway) { setup[:default] }
  let(:rom)     { setup.finalize }
  let(:select)  { rom.relation(:users) }

  before do
    setup.relation(:users) do
      dataset "auth.users"

      def by_id(id)
        where(id: id)
      end
    end
  end

end # shared examples
