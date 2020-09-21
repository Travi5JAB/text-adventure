class CreateReportingTable < ActiveRecord::Migration[5.2]
  def change
    create_table :reports do |t|
      t.string :reason
      t.string :notes
      t.references :game, foreign_key: true
      t.references :user, foreign_key: true
    end
  end
end
