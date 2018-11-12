require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    # @letter = letters.join(" ")
  end

  def score
    # def score_and_message(attempt, grid)
    @letters = params[:letters]
    @word = params[:word]
    included?(@word, @letters)
    compute_score(@word)
    score_and_message(@word, @letters)
    english_word?(@word)

  end

    def english_word?(word)
      response = open("https://wagon-dictionary.herokuapp.com/#{word}")
      json = JSON.parse(response.read)
      return json['found']
    end

    def included?(guess, grid)
      guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
    end

    def compute_score(attempt)
     # time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
     attempt.size * 5
    end

    def score_and_message(attempt, grid)
      if included?(attempt.upcase, grid)
        if english_word?(attempt)
          score = compute_score(attempt)
          @message = [score, "well done"]
        else
          @message = [0, "not an english word"]
        end
      else
        @message = [0, "not in the grid"]
      end
    end

  # end
end
