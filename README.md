**Trial Job**

This is trial job for testing

**Getting Started**

You must change the rest api endpoint from lib/rest_api/default.rb

```ruby
    ENDPOINT = 'http://localhost:3001' unless defined? RestApi::Default::ENDPOINT
```

And API-Key can be configured. There is initializer config/initializer/rest_api.rb

```ruby
    RestApi.configure do |config|
      config.api_key = 'your api key here'
    end
```