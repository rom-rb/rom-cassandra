# encoding: utf-8

describe ROM::Cassandra::Migrations::Logger do

  let(:logger) { described_class.new }
  let(:stdout) { StringIO.new }

  before { $stdout = stdout }
  after  { $stdout = STDOUT }

  describe ".new" do
    subject { logger }

    it { is_expected.to be_kind_of ::Logger }

    it "sends messages to $stdout" do
      expect { subject.info "text" }.to change { stdout.string }.to "text\n"
    end
  end # describe .new

end # describe ROM::Cassandra::Migrations::Logger
