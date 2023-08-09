# frozen_string_literal: true

# class ReportJob
class ReportJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    # puts 'Running ReportJob'
  end
end
