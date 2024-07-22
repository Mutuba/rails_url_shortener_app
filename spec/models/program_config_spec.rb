# require 'rspec'
require 'rails_helper'

require_relative './transfer'
require_relative './program_config'

RSpec.describe ProgramConfig do
  let(:start_date) { Date.new(2024, 1, 1) }
  let(:amount) { 100.0 }

  context 'with weekly cadence' do
    it 'generates weekly transfers' do
      config = ProgramConfig.new('weekly', start_date, 3, amount)
      transfers = config.generate_transfers

      expect(transfers.size).to eq(3)
      expect(transfers[0].scheduled_date_time).to eq(start_date)
      expect(transfers[1].scheduled_date_time).to eq(start_date + 7)
      expect(transfers[2].scheduled_date_time).to eq(start_date + 14)
    end
  end

  context 'with monthly cadence' do
    it 'generates monthly transfers' do
      config = ProgramConfig.new('monthly', start_date, 3, amount)
      transfers = config.generate_transfers

      expect(transfers.size).to eq(3)
      expect(transfers[0].scheduled_date_time).to eq(start_date)
      expect(transfers[1].scheduled_date_time).to eq(start_date.next_month)
      expect(transfers[2].scheduled_date_time).to eq(start_date.next_month(2))
    end
  end

  context 'with end-of-month cadence' do
    it 'generates transfers at the end of the month' do
      config = ProgramConfig.new('monthly', Date.new(2024, 1, 31), 4, amount)
      transfers = config.generate_transfers

      expect(transfers.size).to eq(4)
           
      expect(transfers[0].scheduled_date_time).to eq(Date.new(2024, 1, 31))
      expect(transfers[1].scheduled_date_time).to eq(Date.new(2024, 2, 29))
      expect(transfers[2].scheduled_date_time).to eq(Date.new(2024, 3, 31))
      expect(transfers[3].scheduled_date_time).to eq(Date.new(2024, 4, 30))

    end
  end
end
