require 'spec_helper'

describe RestApi::API::Principals do
  before do
    RestApi.configure{|c| c.api_key = 'test'}
  end

  context 'success' do
    before do
      fixture = File.read(Rails.root.join("spec/fixtures/principals.json"))
      stub_get("/api/v1/principals/list").
        with(:headers => {'Accept'=>'application/json', 'Api-Key'=>'test'}).
        to_return(:status => 200, :body => fixture, :headers => {})
    end

    it "returns body" do
      objects = RestApi.principals
      expect(objects).to be_an Array
      expect(objects.first[:id]).to eq 3
      expect(objects.first[:name]).to eq "Name 1"
    end
  end

  context 'error' do
    before do
      stub_get("/api/v1/principals/list").
        to_return(:status => 401, :body => "401", :headers => {})
    end

    it "raise error when server renders 401" do
      expect{RestApi.principals}.to raise_error(RestApi::Error::Unauthorized)
    end
  end
end