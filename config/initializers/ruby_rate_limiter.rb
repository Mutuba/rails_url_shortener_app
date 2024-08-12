# frozen_string_literal: true

# config/initializers/ruby_rate_limiter.rb
require 'ruby_rate_limiter'
require 'redis'

module RateLimiter
  DEFAULT_TIME_UNIT = :minute

  def self.for(user_identifier:, time_unit: DEFAULT_TIME_UNIT)
    RubyRateLimiter::TokenBucket.new(
      user_identifier:,
      storage: redis_storage,
      time_unit:
    )
  end

  def self.redis_client
    @redis_client ||= Redis.new(url: ENV['REDIS_URL'])
  end

  def self.redis_storage
    @redis_storage ||= RubyRateLimiter::Storage::RedisStorage.new(redis_client)
  end
end
