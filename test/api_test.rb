require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'

class ApiTest < Minitest::Test
  def before_setup
    def conn
      Faraday.new(url: "http://www.omdbapi.com/")
    end
  end

  def test_no_api_key
    response = conn.get("?t=movies")
    json = JSON.parse(response.body, symbolize_names: true)

    assert_equal "False", json[:Response]
    assert_equal "No API key provided.", json[:Error]
    ## Test shows that when API Key not provided user can not retrieve data from API
    ## Reponse == {:Response=>"False", :Error=>"No API key provided."}
  end
end
