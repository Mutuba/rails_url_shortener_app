# frozen_string_literal: true

namespace :db do
  desc 'Delete posts created 10 days ago'
  task delete_old_ulrs: :environment do
    puts 'About to delete old urls'
    Url.all.destroy_all
    puts 'Deleted old urls'
  end
end
