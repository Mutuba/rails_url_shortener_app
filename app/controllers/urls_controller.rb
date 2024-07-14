# frozen_string_literal: true

# UrlsController controller
class UrlsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[show edit update destroy]
  before_action :authenticate_user!

  def index
    return redirect_to get_started_path unless user_signed_in?

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

  def url_params
    params.require(:url).permit(:file, :long_url, :short_url, tag_names: [])
  end

  def handle_tags(url, tags)
    tag_names = tags.split(',').map(&:strip).reject(&:blank?)    
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



