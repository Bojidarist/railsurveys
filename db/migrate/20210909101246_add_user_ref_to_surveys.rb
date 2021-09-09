class AddUserRefToSurveys < ActiveRecord::Migration[5.2]
  def change
    add_reference :surveys, :user, foreign_key: true
  end
end
