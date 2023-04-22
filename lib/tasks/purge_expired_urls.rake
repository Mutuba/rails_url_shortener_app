require 'rake'
namespace :db do
  desc 'Deletes expired URLs'
    task purge_expired_urls: :environment do
      PurgeExpiredUrlsJob.perform_later
    end
end


