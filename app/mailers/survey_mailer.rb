class SurveyMailer < ApplicationMailer
    default from: "surveys@railsurveys.com"
    
    def survey_created
        @username = params[:username]
        @survey = params[:survey]
        mail(to: "admin@railsurveys.com", subject: "New survey created by #{ @username }")
    end
end
