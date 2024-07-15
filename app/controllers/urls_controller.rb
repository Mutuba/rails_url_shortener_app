# frozen_string_literal: true

# UrlsController controller
class UrlsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :rate_limit, only: %i[show]

  def index
    return redirect_to home_path unless user_signed_in?

    @tags = Url.tag_names_for(current_user)
    if params[:tags].present?
      selected_tags = params[:tags].map(&:strip).reject(&:blank?)
      @urls = current_user.urls
                         .with_tags(selected_tags)
                         .page(params[:page])
    else
      @urls = current_user.urls.order(updated_at: :desc).page(params[:page])
    end
  end

  def show
    if @url.log_visit(current_user, request.remote_ip)
      respond_to do |format|
        format.html do
          render inline: <<-HTML.strip_heredoc
            <script>
              var longUrl = '<%= j @url.long_url %>';
              window.open(longUrl, '_blank');
              window.location = '<%= j root_path %>';
            </script>
          HTML
        end
      end
    else
      flash[:alert] = "Failed to track URL visit."
      redirect_to root_path
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
      redirect_to new_url_path, alert: 'File upload in progress. Hold tight'
    rescue StandardError => e
      logger.error("Error while processing file upload: #{e.message}")
      redirect_to new_url_path, alert: 'Error occurred during upload. Please try again later.'
    end
  end

  def edit;end

  def update
    if @url.update(url_params)
      @url.update_tags(params[:url][:tag_names])
      redirect_to urls_path, alert: 'URL was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @url.update(deleted: true)
      flash[:alert] = "Url marked as deleted successfully."
    else
      flash[:error] = "Failed to mark batch as deleted."
    end
    redirect_to urls_path
  end

  private

  def rate_limit
    user_identifier = current_user ? "user:#{current_user.id}" : "ip:#{request.remote_ip}"
    if RateLimiterService.rate_limit_exceeded?(user_identifier)
      flash[:alert] = "Rate limit exceeded."
      redirect_to rate_limit_exceeded_path
    end
  end

  def url_params
    params.require(:url).permit(:file, :long_url, :short_url, tag_names: [])
  end

  def file_missing?
    params[:url].blank? || params[:url][:file].blank?
  end

  def set_url
    @url = Url.active.find(params[:id])
  end
end



