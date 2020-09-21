require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    @random = ('a'..'z').to_a.sample(10)
    @start_time = Time.now.to_i
  end

def check
  validator = true
  @attempt.chars.each do |char|
    validator = false unless @attempt.count(char) <= @letters.count(char)
  end
  validator
end

  def score
    @attempt = params[:attempt]
    @letters = params[:letters]
    @time_elapsed = Time.now.to_i - params[:start_time].to_i
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    @answer = JSON.parse(open(url).read)
    check
    if @answer['found'] && check
      @score = "Your score is #{incriment_score}"
    else
      @score = 'Not a valid word'
    end
  end

  def incriment_score
    session[:score] ||= 0
    session[:score] = session[:score] + @answer['length'] * 100 / @time_elapsed
  end
end
