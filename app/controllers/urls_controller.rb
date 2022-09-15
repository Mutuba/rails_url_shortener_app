class UrlsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[show]

  def index
    @urls = Url.all
  end

  def show; end

  def new
    @url = Url.new
  end

  def create
    file_path = "#{Rails.root}/tmp/bulk-import #{SecureRandom.hex}.csv"
    File.write(file_path, params[:url][:file].read)
    UrlsBulkImportJob.perform_later file_path
  end

  private

  def set_url
    @url = Url.find(params[:id])
  end

  def url_params
    params.require(:url).permit(file: {})
  end
end
