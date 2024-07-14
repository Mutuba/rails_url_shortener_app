# Error module to Handle errors globally
module Error
  module ErrorHandler
    extend ActiveSupport::Concern
    included do
      rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    end

    private
    def record_not_found(_e)
      resource_type = identify_resource_type(_e)      
      respond_to do |format|
        format.html { render 'errors/404', status: :not_found, locals: { resource_type: resource_type } }
      end
    end

    def identify_resource_type(exception)
      case exception.message
      when /Url/
        'Url'
      when /Batch/
        'Batch'
      else
        'Resource'
      end
    end
  end
end