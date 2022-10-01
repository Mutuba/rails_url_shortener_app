# frozen_string_literal: true

class CreateFailedUrls < ActiveRecord::Migration[7.0]
  def change
    create_table :failed_urls, id: :uuid do |t|
      t.string :long_url
      t.references :batch, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
