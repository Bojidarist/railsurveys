class SurveysController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :result]

  def index
    @surveys = Survey.active_surveys
  end

  def show
    begin
      @survey = Survey.find(params[:id])
      @uploader = @survey.user
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end

    redirect_to :root unless @survey.active? || helpers.current_user_has_permissions_to_edit?(@survey)
  end

  def update
    @survey = Survey.find(params[:id])
    return redirect_to :root unless helpers.current_user_has_permissions_to_edit?(@survey)

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

    redirect_to :root unless helpers.current_user_has_permissions_to_edit?(@survey)
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
      @survey.destroy if helpers.current_user_has_permissions_to_edit?(@survey)

      return redirect_to :root
    rescue ActiveRecord::RecordNotFound
      return render plain: "Unable to delete survey"
    end
  end

  def create
    @survey = current_user.surveys.new(survey_params)
    
    if current_user.admin?
      @survey.status = :active
    end

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

      SurveyMailer.with(survey: @survey).survey_created.deliver_later unless current_user.admin?

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
