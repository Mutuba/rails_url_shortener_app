# frozen_string_literal: true

class CreateUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :urls, id: :uuid do |t|
      t.string :long_url
      t.string :short_url
      t.integer :click, default: 0
      t.references :batch, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
