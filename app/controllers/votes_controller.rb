require 'json'

class VotesController < ApplicationController
  before_action :authenticate_user!

  def update

    if vote_params.nil?
      return redirect_to :root
    end

    begin
      @survey = Survey.find_by(id: params[:survey_id])
      @answers = Answer.where(id: get_vote_ids)
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end

    if votes_restricted?
      flash[:danger] = "You cannot vote anymore"
      return redirect_to @survey
    end

    @answers.each {|answer| answer.update({ :votes => answer.votes + 1 })}
    @survey.increment!(:votes)

    redirect_to result_survey_path(@survey.id)
  end

  private
  def get_vote_ids
    vote_ids = []

    if @survey.survey_type == "single_answer"
      vote_ids << vote_params["vote"]
    elsif @survey.survey_type == "multi_answer"
      vote_params.each {|k,v| vote_ids << k.split('vote_')[1] if v == "1"}
    end

    vote_ids
  end

  def vote_params
    begin
      params.require(:post)
    rescue ActionController::ParameterMissing
      return nil
    end
  end

  def votes_restricted?
    return !helpers.can_vote_cookie?(@survey) || !helpers.can_vote_ip?(@survey)
  end
end
