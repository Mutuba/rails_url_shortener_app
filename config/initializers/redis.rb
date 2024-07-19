# frozen_string_literal: true
Redis.new(url: ENV['REDIS_URL'] || 'redis://localhost:6379/0')

