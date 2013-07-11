require 'spec_helper'

describe RestApi do
  before do
    RestApi.configure{|c| c.api_key = 'test'}
  end

  after do
    RestApi.reset!
  end

  context "when delegating to a client" do
    before do
      fixture = File.read(Rails.root.join("spec/fixtures/principals.json"))
      stub_get("/api/v1/principals/list").
        with(:headers => {'Accept'=>'application/json', 'Api-Key'=>'test'}).
        to_return(:status => 200, :body => fixture, :headers => {})
    end

    it "requests the correct resource" do
      RestApi.principals
      expect(a_get('/api/v1/principals/list').with(:headers => {'Accept'=>'application/json', 'Api-Key'=>'test'})).to have_been_made
    end
  end

  describe "respond_to?" do
    it "delegates to RestApi::Client" do
      expect(RestApi.respond_to?(:principals)).to be_true
    end

    it "new client with options" do
      expect(RestApi.respond_to?(:client, true)).to be_true
    end
  end

  describe ".client" do
    it "returns RestApi::Client" do
      expect(RestApi.client).to be_a RestApi::Client
    end

    context "when the options don't change" do
      it "caches the client" do
        expect(RestApi.client).to eq RestApi.client
      end
    end

    context "when the options changed" do
      it "busts the cache" do
        client1 = RestApi.client
        RestApi.configure{|c| c.api_key = "another_key"}
        client2 = RestApi.client
        expect(client1).not_to eq client2
      end
    end
  end
end