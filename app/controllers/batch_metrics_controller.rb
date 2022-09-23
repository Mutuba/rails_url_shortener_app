class BatchMetricsController < ApplicationController
  before_action :set_url, only: %i[upload_status batch_urls]
  before_action :authenticate_user!

  def batch_urls
    if @batch.nil?
      return render template: 'batch_metrics/batch_not_found'  
    end

    return redirect_to root_path, notice: 'Oops, you no authorized to view the resource' if @batch.user != current_user

    @urls = @batch.urls.page(params[:page])
    render template: 'batch_metrics/batch_urls', locals: { urls: @urls , batch: @batch}
  end

  def batch_stats
    @batches = current_user.batches.page(params[:page])
    @batches.order(created_at: :asc)
    render template: 'batch_metrics/batch_metrics'
  end

  def upload_status
    if @batch.nil?
      return render template: 'batch_metrics/batch_not_found'  
    end
    # redirect_to root_path, notice: 'Oops, you no authorized to view the resource' if @batch.user != current_user
    render template: 'batch_metrics/upload_status', locals: { batch: @batch }
  end

  private

  def set_url
    @batch = Batch.find_by(id: params[:id])
  end
end
