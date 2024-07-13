class AddUniqueIndexToTagsName < ActiveRecord::Migration[7.0]
  def change
    add_index :tags, [:name, :taggable_type, :taggable_id], unique: true
  end
end
