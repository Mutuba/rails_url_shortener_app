# frozen_string_literal: true

# BatchMetricsController controller
class BatchMetricsController < ApplicationController
  before_action :set_batch, only: %i[batch_urls destroy]
  before_action :authenticate_user!

  def batch_urls
    return render template: 'batch_metrics/batch_not_found' unless @batch

    @tags = current_user.urls.joins(:tags).distinct.pluck(:name)
    @urls = @batch.urls.order(updated_at: :desc).page(params[:page])
    render template: 'batch_metrics/batch_urls', locals: { urls: @urls, batch: @batch }
  end

  def batch_stats
    @batches = current_user.batches.active.order(created_at: :desc).page(params[:page])
    render template: 'batch_metrics/batch_metrics', locals: { batches: @batches }
  end

  def upload_status
    @batches = current_user.batches.where(success_rate: nil, deleted: false).order(created_at: :desc)
    logger.info "batch_stats #{@batches.count}"
    return render template: 'batch_metrics/batch_not_found' if @batches.empty?

    render template: 'upload_status/upload_status', locals: { batches: @batches }
  end

  def destroy    
    if @batch.update(deleted: true)
      flash[:alert] = "Batch marked as deleted successfully."
    else
      flash[:error] = "Failed to mark batch as deleted."
    end
    redirect_to batch_metrics_batch_stats_path
  end

  private

  def set_batch        
    @batch = Batch.active.find_by(id: params[:id])
  end
end
