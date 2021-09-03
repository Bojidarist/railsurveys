class CreateGeoVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :geo_votes do |t|
      t.string :ip_address
      t.integer :votes
      t.references :survey, foreign_key: true

      t.timestamps
    end
  end
end
