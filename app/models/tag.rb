# == Schema Information
#
# Table name: tags
#
#  id            :uuid             not null, primary key
#  name          :string
#  taggable_type :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  taggable_id   :uuid             not null
#
# Indexes
#
#  index_tags_on_taggable  (taggable_type,taggable_id)
#
class Tag < ApplicationRecord

  validates :name, presence: true
  belongs_to :taggable, polymorphic: true
end
