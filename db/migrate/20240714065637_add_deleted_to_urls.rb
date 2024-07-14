class AddDeletedToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :deleted, :boolean, default: false
  end
end
