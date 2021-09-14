require 'axlsx'

class SiteAdminsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_check
  
  def admin_panel
    @grid = SurveysGrid.new(grid_params) do |scope|
      scope.page(params[:page]).per(5)
    end
  end

  def change_survey_status
    if params["id"] and Survey.statuses[params["status"]]
      @survey = Survey.update(params["id"].to_i, :status => Survey.statuses[params["status"]])
      MailSurveyStatusChangedWorker.perform_async(@survey.id)
    end

    redirect_to site_admins_admin_panel_path
  end

  def download_surveys_xlsx
    surveys = Survey.all
    p = Axlsx::Package.new
    wb = p.workbook

    s = wb.styles
    title_cell_style = s.add_style bg_color: "cacfd2", alignment: { horizontal: :center }

    wb.add_worksheet(name: "Surveys Report") do |sheet|
      sheet.add_row ["ID", "Question", "Status", "Uploader (ID)", "Created At", "Updated At"], style: title_cell_style
      surveys.each do |survey|
        sheet.add_row [survey.id, survey.question, survey.status, "#{survey.user.username} (#{survey.user_id})", survey.created_at, survey.updated_at]
      end
    end

    p.serialize (file = prepare_temp_xlsx_file("surveys_report").path)
    send_file(file)
  end

  private

  def prepare_temp_xlsx_file(file_name)
    temp_file = Tempfile.new([file_name, ".xlsx"], encoding: "ascii-8bit")
    temp_file
  end

  def admin_check
    unless current_user.admin?
      flash[:danger] = "You don't have permissions to view this page."
      redirect_to :root
    end
  end

  def grid_params
    params.fetch(:surveys_grid, {}).permit!
  end
end
