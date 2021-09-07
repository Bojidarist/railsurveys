class SurveysController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :result]

	def index
    @surveys = Survey.all
  end

  def show
    begin
      @survey = Survey.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to :root
    end
  end

  def update
    answer_update_params.each do |key, value|
      if !value.empty?
        answer = Answer.find(key.to_i)
        answer.update({ :description => value })
      end
    end

    redirect_to Survey.find(params[:id])
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
      @survey.destroy

      return redirect_to :root
    rescue ActiveRecord::RecordNotFound
      return render plain: "Unable to delete survey"
    end
  end

  def create
    @survey = Survey.new(survey_params)

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
