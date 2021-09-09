# Preview all emails at http://localhost:3000/rails/mailers/survey_mailer
class SurveyMailerPreview < ActionMailer::Preview
    def survey_created
        SurveyMailer.with(username: User.first.username, survey: Survey.first).survey_created
    end
end
