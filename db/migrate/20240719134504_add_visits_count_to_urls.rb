class AddVisitsCountToUrls < ActiveRecord::Migration[7.0]
  def up
    add_column :urls, :visits_count, :integer, default: 0
  end

  def down
    remove_column :urls, :visits_count
  end
end
