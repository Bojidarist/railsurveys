class AddStatusToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_column :surveys, :status, :integer
  end
end
