# Aetna Testing Challenge

## Table of Contents

- [Introduction](#introduction)
- [Background Information](#background-information)
- [Running Instructions](#running-instructions)
- [Limitations](#limitations)

<!-- Brief Description -->

## Introduction  
The typical response when someone hears the word "test."  
![Test Time](https://thumbs.gfycat.com/EmotionalBeautifulBass-max-1mb.gif)  

All testing done against [OMDB's Movie API](http://www.omdbapi.com/) database.  
Testing tasks were as follows:  
- Successfully make api requests to omdbapi from within tests in api_test.rb  
- Add an assertion to test_no_api_key to ensure the response at runtime matches what is currently displayed with the api key missing  
- Extend api_test.rb by creating a test that performs a search on 'thomas'.  
    - Verify all titles are a relevant match  
    - Verify keys include Title, Year, imdbID, Type, and Poster for all records in the response  
    - Verify values are all of the correct object class  
    - Verify year matches correct format  
- Add a test that uses the i parameter to verify each title on page 1 is accessible via imdbID  
- Add a test that verifies none of the poster links on page 1 are broken  
- Add a test that verifies there are no duplicate records across the first 5 pages  
- Add a test that verifies something you are curious about with regard to movies or data in the database.  

## Background Information  
This is application is built with Ruby 2.5.3 and Rails 6.0.3.4.  
Minitest was used for testing. [Testing File Here](https://github.com/NickEdwin/aetna_test/blob/main/test/api_test.rb)  

## Running Instructions  
To setup locally:
* Clone this repo by running the following commands in your terminal:  
    * `git clone git@github.com:NickEdwin/aetna_test.git`  
    * `cd aetna_test`  
    * `bundle install`  
    * `rails db:create`  
    * `ruby test/api_test.rb` to see tests run.  

When you run `rspec` you should have all test currently passing.   

## Limitations  
I found this API resource to be fairly limited in its responses.   
Would reccomend "The Movie Database" free API for most robust results.  
[API can be found here](https://www.themoviedb.org/documentation/api?language=en-US)   
