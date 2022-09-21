class AddSuccessRateToBatch < ActiveRecord::Migration[7.0]
  def change
    add_column :batches, :success_rate, :integer
  end
end
