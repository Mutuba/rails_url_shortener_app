class UrlShortenerChannel < ApplicationCable::Channel
  def subscribed
    stream_from current_user.id
    Rails.logger.info 'streaming for user id #' + current_user.id + 'in UrlShortenerChannel'
  end

  def unsubscribed
    stop_all_streams
  end
end
