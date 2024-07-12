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
require 'rails_helper'

RSpec.describe Tag, type: :model do

  it { should validate_presence_of(:name) }

  it { should belong_to(:taggable) }
  it { should have_db_column(:taggable_type).of_type(:string) }
  it { should have_db_column(:taggable_id).of_type(:uuid) }
end
