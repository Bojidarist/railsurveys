class AddSurveyTypeToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :survey_type, :string, :default => "single_answer"
  end
end
