# Error module to Handle errors globally
module Error
  module ErrorHandler
    extend ActiveSupport::Concern
    included do
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    end

    private
    def record_not_found(_e)
      respond_to do |format|
        format.html { render 'errors/404', status: :not_found }
      end
    end
  end
end