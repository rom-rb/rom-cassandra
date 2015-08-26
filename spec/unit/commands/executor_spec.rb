# encoding: utf-8

describe ROM::Cassandra::Commands::Executor do

  let(:klass)  { Class.new }
  let(:object) { klass.new }

  before { klass.send :include, described_class }

  describe "#dataset" do
    subject { object.dataset }

    it "returns the #relation's #source" do
      allow(object).to receive(:relation) { double source: :foo }

      expect(subject).to eql(:foo)
    end
  end # describe #dataset

  describe "#query" do
    subject { object.query }

    it "is an attribute" do
      object.instance_variable_set :@query, :foo
      expect(subject).to eql(:foo)
    end
  end # describe #query

  describe "#execute" do
    context "without a block" do
      subject { object.execute(:foo, :bar) }

      it "returns result of the query" do
        allow(object).to receive(:query) { double :query, to_a: [:baz] }

        expect(subject).to eql([:baz])
      end
    end

    context "with a block" do
      subject { object.execute { foo } }

      it "returns result of updated query" do
        updated_query = double :updated_query, to_a: [:bar]
        allow(object).to receive(:query) { double :query, foo: updated_query }

        expect(subject).to eql([:bar])
      end
    end
  end # describe #execute

end # describe ROM::Cassandra::Executor
