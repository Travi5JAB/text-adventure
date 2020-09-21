class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.string :webpage
      t.string :category
      t.timestamps
    end
  end
end
