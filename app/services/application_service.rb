# frozen_string_literal: true

# All services to implement call method
class ApplicationService
  # expects any number of args and
  # a block that implements an operation on the args
  def self.call(*args)
    new(*args).call
  end
end
