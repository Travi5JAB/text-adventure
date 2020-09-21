class AddCreatorToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :creator, :string
  end
end
