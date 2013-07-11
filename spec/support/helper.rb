
def stub_get(path)
  stub_request(:get, RestApi::Default::ENDPOINT + path)
end

def a_get(path)
  a_request(:get, RestApi::Default::ENDPOINT + path)
end