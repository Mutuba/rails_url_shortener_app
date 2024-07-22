require 'date'

class ProgramConfig
  attr_accessor :cadence, :start_date_time, :num_of_transfers, :amount

  def initialize(cadence, start_date_time, num_of_transfers, amount)
    @cadence = cadence
    @start_date_time = start_date_time
    @num_of_transfers = num_of_transfers
    @amount = amount
  end
  def generate_transfers
    transfers = []
    current_date = start_date_time
  
    num_of_transfers.times do
      case cadence
      when 'weekly'
        transfers << Transfer.new(current_date, amount)
        current_date += 7
      when 'monthly'
        transfers << Transfer.new(current_date, amount)
  
        next_month = current_date.next_month
        if current_date.day == current_date.end_of_month.day &&
          current_date.day < next_month.end_of_month.day
          current_date = next_month.end_of_month
        else
          current_date = next_month
        end
      end
    end
  
    transfers
  end

    transfers
  end
end
