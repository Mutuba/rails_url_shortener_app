every 1.minutes do
  rake 'db:purge_expired_urls'
end


every 1.minutes do
  rake 'db:delete_old_ulrs'
end