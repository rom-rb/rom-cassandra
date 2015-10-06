# encoding: utf-8

require "transproc/rspec"

describe ROM::Cassandra::Functions do

  describe "#to_uri" do
    let(:arguments) { [:to_uri] }

    it_behaves_like :transforming_immutable_data do
      let(:input)  { "127.0.0.2:9043" }
      let(:output) { { hosts:  %w(127.0.0.2), port: 9043 } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { "127.0.0.2" }
      let(:output) { { hosts:  %w(127.0.0.2), port: 9042 } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { ":9043" }
      let(:output) { { hosts:  %w(127.0.0.1), port: 9043 } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { nil }
      let(:output) { { hosts:  %w(127.0.0.1), port: 9042 } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { { hosts: %w(127.0.0.1 127.0.0.2), port: 9043, foo: :bar } }
      let(:output) { { hosts: %w(127.0.0.1 127.0.0.2), port: 9043, foo: :bar } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { { hosts: %w(127.0.0.1 127.0.0.2), foo: :bar } }
      let(:output) { { hosts: %w(127.0.0.1 127.0.0.2), port: 9042, foo: :bar } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { { port: 9043, foo: :bar } }
      let(:output) { { hosts: %w(127.0.0.1), port: 9043, foo: :bar } }
    end

    it_behaves_like :transforming_immutable_data do
      let(:input)  { { foo: :bar } }
      let(:output) { { hosts: %w(127.0.0.1), port: 9042, foo: :bar } }
    end
  end # describe #to_uri

end # describe ROM::Cassandra::Functions
