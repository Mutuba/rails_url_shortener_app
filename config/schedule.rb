every 1.minutes do
  rake 'db:purge_expired_urls'
end