# frozen_string_literal: true

# UrlsController controller
class UrlsController < ApplicationController
  require 'securerandom'

  before_action :set_url, only: %i[show]
  before_action :authenticate_user!, except: %i[index]

  def index
    return redirect_to get_started_path unless user_signed_in?

    @urls = current_user.urls.order(updated_at: :desc).page(params[:page])
  end

  def show
    render 'errors/404', status: :not_found if @url.nil?
    @url.update(click: @url.click + 1)
    redirect_to @url.long_url, allow_other_host: true
  end

  def new
    @url = Url.new
  end

  def create
    if file_missing?
      flash[:alert] = 'Oops! File missing'

      return redirect_to new_url_path
    end

    base_url = request.base_url
    file = params[:url][:file]

    FileWriterService.call(
      file:,
      base_url:,
      current_user:,
    )

    redirect_to new_url_path, alert: 'Upload in progress. Please sit tight'
  end

  private

  def file_missing?
    params[:url].blank?
  end

  def set_url
    @url = Url.find_by(id: params[:id])
  end
end
