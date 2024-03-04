require 'open-uri'
require 'json'
require 'net/http'

class GamesController < ApplicationController

  def new
    @letters = []
    for i in (1..10)
      @letters << ('a'..'z').to_a.sample.upcase
    end
    @start_time = Time.now
  end

  def score
    @end_time = Time.now
    @start_time = params[:start_time]
    @letters = params[:letters].gsub(/[^a-zA-Z]/, "")
    @word = params[:attempt].upcase
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    user_serialized = URI.open(url).read
    user = JSON.parse(user_serialized)
    # result hash
    @result = {
      score: 0,
      message: 'Not working',
      time: 0
    }

    # time to reply
    @result[:time] = @end_time.to_i - @start_time.to_i

    # validate word

    if @word
      if @word.chars.all? { |letter| @word.count(letter) <= @letters.count(letter) }
        if user['found']
          @result[:score] = 100 * @word.length
          @result[:message] = 'well done!'
        else
          @result[:message] = 'not an english word'
        end
      else
        @result[:message] = 'not in the grid'
      end
      @result
    end
  end
end
