# frozen_string_literal: true

# UrlsController controller
class UrlsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[show edit update destroy]
  before_action :authenticate_user!
  before_action :rate_limit, only: %i[show]

  def index
    return redirect_to home_path unless user_signed_in?

    @tags = current_user.urls.joins(:tags).distinct.pluck(:name)
    if params[:tags].present?
      selected_tags = params[:tags].map(&:strip).reject(&:blank?)
      @urls = current_user.urls
                         .joins(:tags)
                         .where(tags: { name: selected_tags })
                         .group('urls.id')
                         .having('COUNT(tags.id) = ?', selected_tags.count)
                         .order(updated_at: :desc)
                         .page(params[:page])                         
    else
      @urls = current_user.urls.order(updated_at: :desc).page(params[:page])
    end
  end

  def show
    if log_visit
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
      handle_tags(@url, params[:url][:tag_names])
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
    rate_limiter = RateLimiter.for(user_identifier: user_identifier)

    if rate_limiter.allow_request?
      flash[:alert] = "Rate limit exceeded."
      redirect_to rate_limit_exceeded_path
    end
  end

  def log_visit
    return false unless @url
  
    existing_visit = @url.visits.find_by(user_id: current_user&.id, ip_address: request.remote_ip)
  
    if existing_visit
      existing_visit.increment!(:visit_count)
      return true
    end
  
    @url.visits.create(
      user: current_user,
      ip_address: request.remote_ip,
      ip_address: request.remote_ip,
      visit_count: 1
    )
  end

  def url_params
    params.require(:url).permit(:file, :long_url, :short_url, tag_names: [])
  end

  def handle_tags(url, tags)
    tag_names = tags.split(',').map { |tag| tag.strip.downcase }.reject(&:blank?)
    url.tags.where.not(name: tag_names).destroy_all
    tag_names.each do |name|
      url.tags.find_or_create_by(name: name)
    end
  end

  def file_missing?
    params[:url].blank? || params[:url][:file].blank?
  end

  def set_url
    @url = Url.active.find(params[:id])
  end
end



