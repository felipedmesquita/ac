require "ac"
require "mini_mock"

class AcTest < TLDR
  MiniMock.replay
  def test_that_it_has_a_version_number
    refute_nil ::Ac::VERSION
  end

  def test_httpbin_client
    client = HttpbinClient.new
     def client.sleep duration
      puts "sleep(#{duration})"
    end
    res = client.get_ip
    assert_equal 200, res.code
    assert res.json["origin"]
  end
end

class HttpbinClient < Ac::Base
  BASE_URL = "https://httpbin.org"

  def get_ip
    get("/ip") do |response|
      # Use the block to retry the request if the response is not what you expect
      # here it will fail once because the first response is set in mocks.rb to return invalid json
      # puts "Received body containing: #{response.body}"
      response.json["origin"]
    end
  end
end
