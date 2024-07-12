class AddTaggableToTag < ActiveRecord::Migration[7.0]
  def change
    add_reference :tags, :taggable, polymorphic: true, null: false, type: :uuid, imdex: true
  end
end
