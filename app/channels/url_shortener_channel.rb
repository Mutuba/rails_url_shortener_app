class UrlShortenerChannel < ApplicationCable::Channel
  def subscribed
    # puts 'Mutuba the boss'
    stream_for current_user
    stream_from 'UrlShortenerChannel'
  end

  def unsubscribed
    stop_all_streams
  end

  def receive(_data)
    puts 'Mutuba the boss'
  end
end
