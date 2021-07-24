class VotesController < ApplicationController
	def update
    begin
      @answer = Answer.find(vote_params["vote"])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
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
		params.require(:post)
	end
end
