# frozen_string_literal: true

# DownloadCsvController controller
class DownloadCsvController < ApplicationController
  require 'csv'
  before_action :authenticate_user!

  def download_sample_csv
    send_file 'public/Sample_urls_upload_file_medium_large.csv',
              filename: 'Sample_urls_upload_file_medium_large.csv'
  end
end
