class SurveyMailer < ApplicationMailer
    default from: "surveys@railsurveys.com"
    
    def survey_created
        @survey = params[:survey]
        mail(to: "admin@railsurveys.com",
            subject: "New survey created by #{ @survey.user.username }")
    end
end
