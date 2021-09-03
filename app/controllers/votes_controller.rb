require 'json'

class VotesController < ApplicationController
  def update

    if vote_params.nil?
      return redirect_to :root
    end

    begin
      @answer = Answer.find(vote_params["vote"])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end

    # Restrict vote using a cookie
    if cookies[:num_votes].nil?
      cookies[:num_votes] = { :num_votes => [ { :survey_id => @answer.survey_id, :vote => true } ] }.to_json
    else
      num_votes_cookie = JSON.parse(cookies[:num_votes])
      is_survey_in_cookie = false

      num_votes_cookie["num_votes"].each do |value|
        if value["survey_id"] == @answer.survey_id
          is_survey_in_cookie = true
          if value["vote"]
            flash[:danger] = "You can only vote once"
            return redirect_to survey_path(@answer.survey_id)
          else
            num_votes_cookie["num_votes"].append( { :survey_id => @answer.survey_id, :vote => true } )
            cookies[:num_votes] = num_votes_cookie.to_json
          end
        end
      end

      unless is_survey_in_cookie
        num_votes_cookie["num_votes"].append( { :survey_id => @answer.survey_id, :vote => true } )
        cookies[:num_votes] = num_votes_cookie.to_json
      end
    end

    if @answer.update({ :votes => @answer.votes + 1 })
      @survey = Survey.find(@answer.survey_id) 
      redirect_to result_survey_path(@survey.id)
    else
      redirect_to :root
    end
  end

  private
  def vote_params
    begin
      params.require(:post)
    rescue ActionController::ParameterMissing
      return nil
    end
  end
end
