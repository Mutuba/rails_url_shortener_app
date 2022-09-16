# == Schema Information
#
# Table name: batches
#
#  id         :uuid             not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Batch < ApplicationRecord
  has_many :urls
end
