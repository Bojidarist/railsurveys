class SurveyMailer < ApplicationMailer
    default from: "surveys@railsurveys.com"
    
    def survey_created
        @survey = params[:survey]
        mail(to: User.admins.pluck(:email),
            subject: "New survey created by #{ @survey.user.username }")
    end
end
