# frozen_string_literal: true

class UrlShortenerChannel < ApplicationCable::Channel
  def subscribed
    user_id = current_user.id
    batch_id = params[:batch_id]
    
    Rails.logger.info "Subscribing to user and batch channels for user id #{user_id} and batch id #{batch_id} in UrlShortenerChannel"

    reject if user_id.nil?
    reject if batch_id.blank?

    stream_from "user_#{user_id}_batch_#{batch_id}"
    Rails.logger.info "Streaming for user id #{user_id} and batch id #{batch_id} in UrlShortenerChannel"
  end

  def unsubscribed
    stop_all_streams
  end
end
