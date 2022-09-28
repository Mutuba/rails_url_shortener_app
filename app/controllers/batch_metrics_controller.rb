class BatchMetricsController < ApplicationController
  before_action :set_url, only: %i[upload_status batch_urls]
  before_action :authenticate_user!

  def batch_urls
    return render template: 'batch_metrics/batch_not_found' if @batch.nil?

    @urls = @batch.urls.page(params[:page])
    render template: 'batch_metrics/batch_urls', locals: { urls: @urls, batch: @batch }
  end

  def batch_stats
    @batches = current_user.batches.page(params[:page])
    @batches.order(created_at: :desc)
    render template: 'batch_metrics/batch_metrics'
  end

  def upload_status
    return render template: 'batch_metrics/batch_not_found' if @batch.nil?

    render template: 'batch_metrics/upload_status', locals: { batch: @batch }
  end

  def current_upload_status
    batch = Batch.last
    return render template: 'batch_metrics/batch_not_found' if batch.nil?

    render template: 'batch_metrics/current_upload_status', locals: { batch: batch }
  end

  private

  def set_url
    @batch = Batch.find_by(id: params[:id])
  end
end
