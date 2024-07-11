# frozen_string_literal: true

# ApplicationController controller
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include Error::ErrorHandler

  include Devise::Controllers::Helpers

end
