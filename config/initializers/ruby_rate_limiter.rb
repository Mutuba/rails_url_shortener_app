# config/initializers/ruby_rate_limiter.rb
require 'ruby_rate_limiter'
require 'redis'

module RateLimiter
  DEFAULT_BUCKET_SIZE = 10
  DEFAULT_REFILL_RATE = 1
  DEFAULT_TIME_UNIT = :minute

  def self.for(user_identifier:, bucket_size: DEFAULT_BUCKET_SIZE, refill_rate: DEFAULT_REFILL_RATE, time_unit: DEFAULT_TIME_UNIT)
    RubyRateLimiter::TokenBucket.new(
      user_identifier: user_identifier,
      storage: RubyRateLimiter::Storage::RedisStorage.new(redis_client),
      bucket_size: bucket_size,
      refill_rate: refill_rate,
      time_unit: time_unit
    )
  end

  private

  def self.redis_client
    @redis_client ||= Redis.new(url: ENV['REDIS_URL'])
  end
end

