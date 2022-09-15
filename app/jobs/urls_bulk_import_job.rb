class UrlsBulkImportJob < ApplicationJob
  queue_as :default

  # Bulk upload urls
  def perform(file_path, base_url)
    BulkUrlsImportService.call({ file_path: file_path, base_url: base_url })
  end
end
