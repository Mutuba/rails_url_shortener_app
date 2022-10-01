# frozen_string_literal: true

class ApplicationService
  # expects any number of args and
  # a block that implements an operation on the args
  def self.call(*args)
    new(*args).call
  end
end
