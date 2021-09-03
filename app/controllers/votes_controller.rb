require 'json'

class VotesController < ApplicationController
  def update

    if vote_params.nil?
      return redirect_to :root
    end

    begin
      @answer = Answer.find(vote_params["vote"])
      @survey = Survey.find(@answer.survey_id)
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end

    if votes_restricted?(@answer, @survey)
      flash[:danger] = "You cannot vote anymore"
      return redirect_to @survey
    end
    
    if @answer.update({ :votes => @answer.votes + 1 })
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

  def votes_restricted?(answer, survey)
    return !helpers.can_vote_cookie?(answer) || !helpers.can_vote_ip?(survey)
  end
end
