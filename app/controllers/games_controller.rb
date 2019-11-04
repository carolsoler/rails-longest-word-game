require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = [*('A'..'Z')].sample(10)
  end

  def score
    @answer = compare_word
  end

  def compare_word
    @result = []
    @letters = params[:letters].downcase.split(' ')
    @word = params[:word].downcase.split('')
    @word.each do |letter|
      if @letters.include?(letter)
        @result << letter
        @letters.delete(letter)
      end
    end
    results
  end

  def parse(word)
    url = open("https://wagon-dictionary.herokuapp.com/#{word}")
    user = JSON.parse(url.read)
    user['found']
  end

  def results
    if @result.length != @word.length
      @show = "Sorry but #{params[:word].upcase} can't be built with #{params[:letters]}"
    elsif parse(@result.join)
      @show = "Congrats, #{params[:word].upcase} is a valid English word"
    else
      @show = "Sorry, #{params[:word].upcase} is not a valid English word..."
    end
    @show
  end
end
