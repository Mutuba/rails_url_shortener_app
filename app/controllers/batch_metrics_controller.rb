class BatchMetricsController < ApplicationController
  require 'securerandom'
  before_action :set_url, only: %i[download_status batch_urls]
  before_action :authenticate_user!

  def index
    @batches = current_user.batches.includes(:urls)
  end

  def batch_urls
    redirect_to root_path, notice: 'Oops, you no authorized to view the resource' if @batch.user != current_user

    # binding.pry

    @urls = @batch.urls.page(params[:page])
    render template: 'batch_metrics/batch_urls', locals: { urls: @urls }
  end

  def batch_stats
    @batches = current_user.batches
    @batches.order(created_at: :desc)
    render template: 'batch_metrics/batch_metrics'
  end

  def download_status
    render template: 'batch_metrics/download_status', locals: { batch: @batch }
  end

  private

  def set_url
    @batch = Batch.find(params[:id])
  end
end
