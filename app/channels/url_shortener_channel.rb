class UrlShortenerChannel < ApplicationCable::Channel
  def subscribed
    puts 'Subscribed to Room Channel', current_user.id
    stream_from current_user.id
    # stream_from 'UrlShortenerChannel'
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(_data)
    puts 'Mutuba the boss'
  end
end
