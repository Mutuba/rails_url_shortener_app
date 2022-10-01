# frozen_string_literal: true

# ApplicationCable module
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def current_user
      env['warden'].user
    end

    def find_verified_user
      current_user || reject_unauthorized_connection
    end
  end
end
