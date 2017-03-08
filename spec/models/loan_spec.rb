require 'rails_helper'

RSpec.describe Loan, type: :model do

  describe 'outstanding_balance' do
    context "with no payments" do
      let(:loan) { Loan.create!(funded_amount: 100.0) }

      it 'should equal the funded amount initially' do
        expect(loan.outstanding_balance).to eq(loan.funded_amount)
      end
    end

    context "with payments" do
      let(:loan) {
        l = Loan.create!(funded_amount: 100.0)
        l.payments << Payment.create!(loan: l, payment_amount: 10.0, payment_date: "2017-01-01")
        l.payments << Payment.create!(loan: l, payment_amount: 10.0, payment_date: "2017-02-01")
        l
      }

      it 'should equal the funded amount minus any payments' do
        loan.reload
        expect(loan.outstanding_balance).to eq((loan.funded_amount - loan.payments.sum(:payment_amount)))
      end
    end
  end

end
