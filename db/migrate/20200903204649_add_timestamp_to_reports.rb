class AddTimestampToReports < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :reports, null: true
    change_column_null :reports, :created_at, false
    change_column_null :reports, :updated_at, false
  end
end
