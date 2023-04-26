class WorkerJob
  include Sidekiq::Worker

  def perform
    puts "Running job now..."
  end
end