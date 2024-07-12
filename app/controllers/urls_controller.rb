# frozen_string_literal: true

# UrlsController controller
class UrlsController < ApplicationController
  require 'securerandom'

  before_action :set_url, only: %i[show]
  before_action :authenticate_user!

  def index
    return redirect_to get_started_path unless user_signed_in?
     
    @urls = current_user.urls.order(updated_at: :desc).page(params[:page])
  end

  def show
    if @url.update(click: @url.click + 1)
      respond_to do |format|
        format.html do
          render inline: <<-HTML.strip_heredoc
            <script>
              var longUrl = '<%= j @url.long_url %>';
              var rootPath = '<%= j root_path %>';
              window.open(longUrl, '_blank');
              window.location = rootPath;
            </script>
          HTML
        end
      end 
    end
  end

  def new
    @new_url = Url.new
  end

  def create
    if file_missing?
      flash[:alert] = 'Oops! File missing'
      return redirect_to new_url_path
    end

    base_url = request.base_url
    file = url_params[:file]

    begin
      FileWriterService.call(
        file: file,
        base_url: base_url,
        current_user: current_user
      )
      redirect_to new_url_path  
    rescue StandardError => e
      logger.error("Error while processing file upload: #{e.message}")
      redirect_to new_url_path, alert: 'Error occurred during upload. Please try again later.'
    end
  end

  private

  def url_params
    params.require(:url).permit(:file)
  end

  def file_missing?
    params[:url].blank? || params[:url][:file].blank?
  end

  def set_url
    @url = Url.find_by!(id: params[:id])
  end
end
