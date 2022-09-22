class UrlsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[show]
  before_action :authenticate_user!

  def index
    @urls = current_user.urls.page(params[:page])
  end

  def show
    render 'errors/404', status: 404 if @url.nil?
    @url.update_attribute(:click, @url.click + 1)
    redirect_to @url.long_url, allow_other_host: true
  end

  def new
    @url = Url.new
  end

  def create
    base_url = request.base_url
    file_path = "#{Rails.root}/tmp/bulk-import #{SecureRandom.hex}.csv"
    File.write(file_path, params[:url][:file].read)
    UrlsBulkImportJob.perform_later file_path, base_url, current_user
    redirect_to new_url_path, notice: 'New URL was successfully created.'
  end

  private

  def set_url
    @url = Url.find(params[:id])
  end
end
