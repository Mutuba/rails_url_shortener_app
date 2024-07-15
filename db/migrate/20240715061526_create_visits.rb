class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits, id: :uuid do |t|
      t.references :url, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.string :ip_address
      t.integer :visit_count, default: 0, null: false

      t.timestamps
    end
  end
end
