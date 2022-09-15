class UrlsBulkImportJob < ApplicationJob
  queue_as :default

  # Bulk upload urls
  def perform(file_path)
    BulkUrlsImportService.call({ file_path: file_path })
  end
end
