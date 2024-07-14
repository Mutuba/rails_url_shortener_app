class AddDeletedToBatches < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :deleted, :boolean, default: false
  end
end
