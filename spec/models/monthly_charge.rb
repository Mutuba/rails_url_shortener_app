# frozen_string_literal: true

require 'date'

def monthly_charge(month, subscription, users)
  # get the month start and end
  month_start = Date.parse("#{month}-01")
  month_end = month_start.end_of_month

  daily_rate = subscription[:monthly_price_in_cents] / month_start.end_of_month.day
  total_charge = 0

  users.each do |user|
    # Determine the effective activation and deactivation dates for the user within the month
    effective_start = [user[:activated_on], month_start].max
    effective_end = [user[:deactivated_on] || month_end, month_end].min

    # Skip the user if they weren't active during the month
    next if effective_start > month_end || effective_end < month_start

    # Calculate the number of days the user was active within the month
    active_days = (effective_end - effective_start + 1).to_i

    # Accumulate charges
    total_charge += active_days * daily_rate
  end
  total_charge.round
end
