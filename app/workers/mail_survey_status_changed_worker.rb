class MailSurveyStatusChangedWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5

  def perform(survey_id)
    survey = Survey.find(survey_id)
    SurveyMailer.with(survey: survey).survey_status_changed.deliver
  end
end
