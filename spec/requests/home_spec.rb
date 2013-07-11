require 'spec_helper'

describe 'root' do
  before do
    RestApi.configure {|c| c.api_key = 'test'}

    fixture = File.read(Rails.root.join("spec/fixtures/principals.json"))
    stub_get("/api/v1/principals/list").
      with(:headers => {'Accept'=>'application/json', 'Api-Key'=>'test'}).
      to_return(:status => 200, :body => fixture, :headers => {})

    get '/'
  end

  it 'should render objects' do
    objs = RestApi.principals
    expect(response.body).to include objs.first[:name].to_s
  end
end