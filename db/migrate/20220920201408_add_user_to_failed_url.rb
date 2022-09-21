class AddUserToFailedUrl < ActiveRecord::Migration[7.0]
  def change
    add_reference :failed_urls, :user, null: false, foreign_key: true, type: :uuid
  end
end
