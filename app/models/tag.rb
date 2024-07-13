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
#  index_tags_on_name_and_taggable_type_and_taggable_id  (name,taggable_type,taggable_id) UNIQUE
#  index_tags_on_taggable                                (taggable_type,taggable_id)
#
class Tag < ApplicationRecord

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: [:taggable_type, :taggable_id] }
  belongs_to :taggable, polymorphic: true
end


# class GoodnessValidator < ActiveModel::Validator
#   def validate(record)
#     if record.first_name == "Evil"
#       record.errors.add :base, "This person is evil"
#     end
#   end
# end

# class Person < ApplicationRecord
#   validates_with GoodnessValidator
# end

# class Account < ApplicationRecord
#   validates :password, confirmation: true,
#     unless: Proc.new { |a| a.password.blank? }
# end

# validates :password, confirmation: true, unless: -> { password.blank? }
