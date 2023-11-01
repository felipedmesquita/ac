# Ac
Api Client for Typhoeus

### Features
- defines convenience methods for get, post, put, patch, and delete
- allows passing a block to the convenience mehtods to handle retry logic
- prepends a module to Typhoeus::Response that provides a `.json` method that returns parsed JSON or `nil` if parsing fails.

## Installation
Add `gem "ac"` to your Gemfile or install it yourself with `gem install ac`.


## Usage
Subclass Ac::Base and define BASE_URL, then you can use `get(path, options)` (or put/patch/delete).
```ruby
class HttpbinClient < Ac::Base
  BASE_URL = "https://httpbin.org"

  def my_ip_address
    get("/ip").json["origin"]
  end
end

client = HttpbinClient.new
puts client.my_ip_address
# => 177.62.72.86
```
Implement retries by passing a block that blows up or retruns false if the resquest should be retried.
```ruby
class JsonPlaceholderClient < Ac::Base
  BASE_URL = "https://jsonplaceholder.typicode.com"

  def find_post id
    res = get("posts/#{id}") do |response|
      Integer(response.json["id"])
    end
    res.json
  end
end

client = JsonPlaceholderClient.new
puts client.find_post 2
# => {"userId"=>1, "id"=>2, "title"=>"qui est esse", "body"=>"est rerum tempore vi...
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/felipedmesquita/ac.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
