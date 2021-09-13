class SurveysGrid < BaseGrid

  scope do
    Survey
  end

  filter(:id, :integer)
  filter(:question)
  filter(:dynamic_condition, :dynamic, :select => [:question, :id, :status], :header => "Dynamic Condition")
  filter(:status, :enum, :select => Survey.statuses)
  filter(:created_at, :date, :range => true, input_options: {type: 'date'})

  column(:id)
  column(:question) do |model|
    format(model.question) do |value|
      link_to value, model
    end
  end
  column(:status)
  date_column(:created_at)
  column(:actions, :html => true) do |record|
    render :partial => "/site_admins/surveysgrid_actions", :locals => {:survey => record}
  end

end
