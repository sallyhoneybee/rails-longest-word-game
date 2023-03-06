require 'open-uri'
require 'json'

class GamesController < ApplicationController
  before_action :fetch_score
  after_action :fetch_score


  def new
    @random_letter = ('A'..'Z').to_a.sample(10)
  end

  def score
    @word = params[:word]
    @random_letter = params[:random]

    dictionary_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{@word}").read
    dictionary = JSON.parse(dictionary_serialized)

    @display = check_word(@word, dictionary, @random_letter)
  end

  private

  def check_word(word, dictionary, random_letter)
    word.upcase!

    return "Sorry, but #{word} can't be built out of #{random_letter}" unless word.chars.all? { |c| random_letter.count(c) >= word.count(c) }
    return "Sorry, but #{word} does not seem to be a valid english word" if dictionary['found'] != true

    increment_score
    "Congratulations! #{word} is a valid english word!"
  end

  def fetch_score
    session[:score] ||= 0
    @current_score = session[:score]
  end

  def increment_score
    session[:score] += 1
    @current_score = session[:score]
  end
end
