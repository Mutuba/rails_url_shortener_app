class UrlsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[show]
  before_action :authenticate_user!

  def index
    @batches = current_user.batches.includes(:urls)
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
    # Turbo::StreamsChannel.broadcast_append_to('uploads',
    #                                           target: 'All the news fit to print')
    base_url = request.base_url
    file_path = "#{Rails.root}/tmp/bulk-import #{SecureRandom.hex}.csv"
    File.write(file_path, params[:url][:file].read)
    UrlsBulkImportJob.perform_later file_path, base_url, current_user
    # redirect_to new_url_path
  end

  private

  def set_url
    @url = Url.find_by_short_url(params[:id])
  end

  def url_params
    params.require(:url).permit(file: {})
  end
end
