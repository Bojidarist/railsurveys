class SurveysController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :result]

	def index
    @surveys = Survey.all
  end

  def show
    begin
      @survey = Survey.find(params[:id])
      @uploader = @survey.user
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end
  end

  def update
    @survey = Survey.find(params[:id])
    return redirect_to :root unless helpers.is_current_user_uploader?(@survey.user)

    answer_update_params.each do |key, value|
      if !value.empty?
        answer = Answer.find(key.to_i)
        answer.update({ :description => value })
      end
    end

    return redirect_to @survey
  end

  def new
    @survey = Survey.new
    2.times { @survey.answers.build }
  end

  def edit
    begin
      @survey = Survey.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end

    redirect_to :root unless helpers.is_current_user_uploader?(@survey.user)
  end

  def result
    begin
      @survey = Survey.find(params[:id])
      @total_votes = 0

      @survey.answers.each do |answer|
        @total_votes += answer.votes
      end
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end
  end

  def destroy
    begin
      @survey = Survey.find(params[:id])
      @survey.destroy if helpers.is_current_user_uploader?(@survey.user)

      return redirect_to :root
    rescue ActiveRecord::RecordNotFound
      return render plain: "Unable to delete survey"
    end
  end

  def create
    @survey = current_user.surveys.new(survey_params)

    unless helpers.valid_number_of_answers?(answer_params)
      @survey.errors.add(" ", "You must write at least 2 answers")
      return render "new"
    end

    if (@survey.save)
      answer_params.each do |key, value|
        unless value["description"].empty? 
          @survey.answers.create(description: value["description"], votes: 0)
        end
      end

      SurveyMailer.with(username: current_user.username, survey: @survey).survey_created.deliver_later

      redirect_to @survey
    else
      render "new"
    end

  end

  private

  def survey_params
    params.require(:survey).permit(:question)
  end

  def answer_params
    params.require(:survey)["answers_attributes"]
  end

  def answer_update_params
    params.require(:survey)
  end
end
