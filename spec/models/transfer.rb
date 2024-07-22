class Transfer
  attr_accessor :scheduled_date_time, :amount

  def initialize(scheduled_date_time, amount)
    @scheduled_date_time = scheduled_date_time
    @amount = amount
  end
end
