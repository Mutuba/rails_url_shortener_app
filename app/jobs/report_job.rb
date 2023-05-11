class ReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts "Running ReportJob"
  end
end
