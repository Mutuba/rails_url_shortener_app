# frozen_string_literal: true

# ApplicationController controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  include Devise::Controllers::Helpers
end
