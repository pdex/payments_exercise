class Loan < ActiveRecord::Base
  has_many :payments

  def outstanding_balance
    funded_amount - payments.sum(:payment_amount)
  end

  def as_json(options={})
    super(
      :only => [
        :id,
        :funded_amount,
      ],
      :methods => [:outstanding_balance],
    )
  end
end
