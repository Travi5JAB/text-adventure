class AddCreatorIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_reference :games, :user, index: true
  end
end
