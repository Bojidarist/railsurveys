class MailSurveyCreatedWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(survey_id)
    survey = Survey.find(survey_id)
    SurveyMailer.with(survey: survey).survey_created.deliver
  end
end
