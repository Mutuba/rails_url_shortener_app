# frozen_string_literal: true

# == Schema Information
#
# Table name: urls
#
#  id         :uuid             not null, primary key
#  click      :integer          default(0)
#  deleted    :boolean          default(FALSE)
#  long_url   :string
#  short_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  batch_id   :uuid             not null
#  user_id    :uuid             not null
#
# Indexes
#
#  index_urls_on_batch_id  (batch_id)
#  index_urls_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (batch_id => batches.id)
#  fk_rails_...  (user_id => users.id)
#

class Url < ApplicationRecord
  include Taggable

  belongs_to :batch
  belongs_to :user
  validates :long_url, presence: true, length: { minimum: 30 }
  validates :user_id, :batch_id, :short_url, presence: true

  scope :active, -> { where(deleted: false) }
  scope :recently_created, -> { order(created_at: :desc) }
  has_many :visits, dependent: :destroy

  scope :active, -> { where(deleted: false) }

  def self.tag_names_for(user)
    user.urls.joins(:tags).distinct.pluck(:name)
  end

  def self.with_tags(tag_names)
    joins(:tags)
      .where(tags: { name: tag_names })
      .group('urls.id')
      .having('COUNT(tags.id) = ?', tag_names.count)
      .order(updated_at: :desc)
  end

  def log_visit(user, ip_address)
    existing_visit = visits.find_by(user_id: user&.id, ip_address: ip_address)

    if existing_visit
      existing_visit.increment!(:visit_count)
      true
    else
      visits.create(user: user, ip_address: ip_address, visit_count: 1)
      true
    end
  rescue StandardError => e
    Rails.logger.error("Error logging visit: #{e.message}")
    false
  end

  def update_tags(tag_names)
    tag_names = tag_names.split(',').map(&:strip).reject(&:blank?).map(&:downcase)
    current_tags = tags.pluck(:name)

    new_tags = tag_names - current_tags
    old_tags = current_tags - tag_names

    tags.where(name: old_tags).destroy_all
    new_tags.each { |name| tags.find_or_create_by(name: name) }
  end
end
