class AddBatchNoToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :batch_no, :uuid, null: false
  end
end
