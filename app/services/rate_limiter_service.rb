class RateLimiterService
  def self.rate_limit_exceeded?(user_identifier)
    rate_limiter = RateLimiter.for(user_identifier: user_identifier)
    !rate_limiter.allow_request?
  end
end
