# frozen_string_literal: true

# All services to implement call method
class ApplicationService
  # expects any number of args
  def self.call(**args)
    new(**args).call
  end

  private_class_method :new
end
