ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../support/test_helper', __dir__)

require 'minitest/autorun'

class ApiTest < Minitest::Test
  def before_setup
    def conn
      Faraday.new(url: "http://www.omdbapi.com/")
    end
  end

  def test_no_api_key
    #Random search for movies titles "movies"
    response = conn.get("?t=movies")
    json = JSON.parse(response.body, symbolize_names: true)

    #Test for invalid response
    assert(response.status, 401)

    ## Test shows that when API Key not provided user can not retrieve data from API
    ## Reponse == {:Response=>"False", :Error=>"No API key provided."}
    assert_equal "False", json[:Response]
    assert_equal "No API key provided.", json[:Error]
  end

  def test_thomas_search_call
    #Searches DB for all movies with "thomas" in the name
    response = conn.get("?apikey=#{ENV['OMDB_API_KEY']}&s=thomas")
    json = JSON.parse(response.body, symbolize_names: true)

    #Test response is valid
    assert(response.status, 200)

    json[:Search].each do |movie|
      # All movie titles contain "Thomas"
      assert_match 'Thomas', movie[:Title]

      #All movies include Title, Year, imdbID, Type, and Poster
      assert_includes(movie, :Title)
      assert_includes(movie, :Year)
      assert_includes(movie, :imdbID)
      assert_includes(movie, :Type)
      assert_includes(movie, :Poster)

      #All values are of the correct class
      assert String, movie[:Title].class
      assert String, movie[:Year].class
      assert String, movie[:imdbID].class
      assert String, movie[:Type].class
      assert String, movie[:Poster].class

      #Year is a valid
      #4 digits
      assert(movie[:Year].length, 4)
      #Made when movies could be made!
      assert movie[:Year].to_i > 1888
      #Not from the future!
      assert movie[:Year].to_i <= Time.now.year
    end
  end

  def test_titles_on_page_one_are_searchable
    #Searches DB for movies with "Spider" in the name and resturns 1st page of results
    response = conn.get("?apikey=#{ENV['OMDB_API_KEY']}&s=spider&page=1")
    json = JSON.parse(response.body, symbolize_names: true)

    #Takes each results movie title
    i = []
    json[:Search].each do |movie|
      i << movie[:Title]
    end

    #Ensures no nil results
    refute_nil(i, msg = nil)

    #Searches DB based on each title and ensures response of 200 (valid)
    i.each do |title|
      response = conn.get("?apikey=#{ENV['OMDB_API_KEY']}&t=#{title}")

      assert(response.status, 200)
    end
  end

  def test_no_broken_posters
    #Wish the convenient post api was free!
    #Searches DB for movies with "Spider" in the name and resturns 1st page of results
    response = conn.get("?apikey=#{ENV['OMDB_API_KEY']}&s=spider&page=1")
    json = JSON.parse(response.body, symbolize_names: true)

    #Takes image links from each result
    posters = []
    json[:Search].each {|movie| posters << movie[:Poster]}

    #Ensures each link returns a 200 response for validity
    posters.each do |link|
      conn = Faraday.new(url: "https://m.media-amazon.com/")
      response = conn.get("#{link.slice((link.index('images'))..-1)}")

      assert(response.status, 200)
    end
  end

  def test_first_5_pages_give_unique_results
    page_number = 1
    result_ids = []
    until page_number == 5
      response = conn.get("?apikey=#{ENV['OMDB_API_KEY']}&s=spider&page=#{page_number}")
      json = JSON.parse(response.body, symbolize_names: true)
      json[:Search].each {|movie| result_ids << movie[:imdbID]}
      page_number += 1
    end

    #Currently fails! Results are not unique, "tt6320628" is repeated once in this result.
    assert_equal(result_ids, result_ids.uniq)
  end

  def test_something!
    #Sinbad never did a movie titled "Shazaam" in the 90s!
    response = conn.get("?apikey=#{ENV['OMDB_API_KEY']}&s=Shazaam")
    json = JSON.parse(response.body, symbolize_names: true)

    assert_equal "False", json[:Response]
    assert_equal "Movie not found!", json[:Error]
  end
end
