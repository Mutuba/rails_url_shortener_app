# frozen_string_literal: true

# BatchMetricsController controller
class BatchMetricsController < ApplicationController
  before_action :set_batch, only: %i[batch_urls]
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
    @batches = current_user.batches.where(success_rate: nil).order(created_at: :desc)
    return render template: 'batch_metrics/batch_not_found' if @batches.empty?

    render template: 'upload_status/upload_status', locals: { batches: @batches }
  end

  private

  def set_batch        
    @batch = Batch.find_by(id: params[:id])
  end
end
