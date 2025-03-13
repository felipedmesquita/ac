require "ac"
require "mini_mock"

class AcTest < TLDR
  MiniMock.replay

  def track_sleep_calls
    sleep_calls = []
    original_sleep = method(:sleep)
    Object.define_method(:sleep) do |duration|
      sleep_calls << duration
    end
    yield
    sleep_calls
  ensure
    Object.define_method(:sleep, original_sleep)
  end

  def test_that_it_has_a_version_number
    refute_nil ::Ac::VERSION
  end

  def test_exponential_backoff
    client = HttpbinClient.new
    sleeps = track_sleep_calls do
      res = client.get_ip
      assert_equal 200, res.response.code
      assert res["origin"]
    end
    assert_equal [1,2,4], sleeps
  end
 
  def test_authorization
    client = HttpbinClient.new("access_token")
    request = client.get_request("/ip")
    assert request.options[:headers]["Authorization"].match? "access_token"
  end

  def test_skip_authentication
    client = HttpbinClient.new("access_token")
    request = client.get_request("/ip", skip_authentication: true)
    assert_nil request.options[:headers]["Authorization"]
  end

  def test_unauthorized
    assert_raises Ac::UnauthorizedError do
      MeliClient.new.get_item("MLB1")
    end
  end
end

class HttpbinClient < Ac::Base
  BASE_URL = "https://httpbin.org"
  MAX_RETRIES = 3

  def get_ip
    get("/ip") do |response|
      response.origin
    end
  end

end

class MeliClient < Ac::Base
  BASE_URL = "https://api.mercadolibre.com" 

  def get_item mlb
    get("/items/#{mlb}")
  end
end
