class SiteAdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_check
  
  def admin_panel
    @pending_surveys = Survey.pending_surveys
  end

  def change_survey_status
    if params["id"] and Survey.statuses[params["status"]]
      @survey = Survey.update(params["id"].to_i, :status => Survey.statuses[params["status"]])
      SurveyMailer.with(survey: @survey).survey_status_changed.deliver_later
    end

    redirect_to site_admins_admin_panel_path
  end

  private

  def admin_check
    unless current_user.admin?
      flash[:danger] = "You don't have permissions to view this page."
      redirect_to :root
    end
  end
end
