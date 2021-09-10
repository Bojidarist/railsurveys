# Preview all emails at http://localhost:3000/rails/mailers/survey_mailer
class SurveyMailerPreview < ActionMailer::Preview
    def survey_created
        SurveyMailer.with(survey: Survey.first).survey_created
    end

    def survey_status_changed
        SurveyMailer.with(survey: Survey.first).survey_status_changed
    end
end
