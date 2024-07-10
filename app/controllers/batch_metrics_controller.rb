# frozen_string_literal: true

# BatchMetricsController controller
class BatchMetricsController < ApplicationController
  before_action :set_batch, only: %i[upload_status batch_urls]
  before_action :authenticate_user!

  def batch_urls
    return render template: 'batch_metrics/batch_not_found' unless @batch

    @urls = @batch.urls.order(updated_at: :desc).page(params[:page])
    render template: 'batch_metrics/batch_urls', locals: { urls: @urls, batch: @batch }
  end

  def batch_stats
    @batches = current_user.batches.order(created_at: :desc).page(params[:page])
    render template: 'batch_metrics/batch_metrics', locals: { batches: @batches }
  end

  def upload_status
    return render template: 'batch_metrics/batch_not_found' unless @batch

    render template: 'batch_metrics/upload_status', locals: { batch: @batch }
  end

  def current_upload_status
    batch = Batch.last
    return render template: 'batch_metrics/batch_not_found' unless batch

    render template: 'batch_metrics/current_upload_status', locals: { batch: batch }
  end

  private

  def set_batch
    @batch = Batch.find_by(id: params[:id])
  end
end
