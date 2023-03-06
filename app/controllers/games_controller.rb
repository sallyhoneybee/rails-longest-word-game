class GamesController < ApplicationController
  def new
    @random_letter = ('a'..'z').to_a.sample(10)
  end

  def score
  end
end
