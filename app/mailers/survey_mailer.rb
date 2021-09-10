class SurveyMailer < ApplicationMailer
    default from: "surveys@railsurveys.com"
    
    def survey_created
        @survey = params[:survey]
        mail(to: User.admins.pluck(:email),
            subject: "New survey created by #{ @survey.user.username }")
    end

    def survey_status_changed
        @survey = params[:survey]
        mail(to: @survey.user.email, subject: "The status of your survey was changed by an admin")
    end
end
