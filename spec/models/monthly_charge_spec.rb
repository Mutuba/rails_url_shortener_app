# frozen_string_literal: true

require 'rails_helper'
require_relative './monthly_charge'

RSpec.describe 'MonthlyCharge' do
  let(:subscription) { { id: 763, customer_id: 328, monthly_price_in_cents: 2000 } }

  it 'should return a charge based on active days' do
    users = [
      {
        id: 1,
        name: 'Employee #1',
        customer_id: 328,
        activated_on: Date.new(2021, 11, 4),
        deactivated_on: Date.new(2022, 4, 10)
      },
      {
        id: 2,
        name: 'Employee #2',
        customer_id: 328,
        activated_on: Date.new(2021, 12, 4),
        deactivated_on: nil
      }
    ]

    charge = monthly_charge('2022-04', subscription, users)
    expect(charge).to eq 2640
  end
end
