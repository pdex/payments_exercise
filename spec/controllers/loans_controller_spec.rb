require 'rails_helper'

RSpec.describe LoansController, type: :controller do
  describe '#index' do
    it 'responds with a 200' do
      get :index
      expect(response).to have_http_status(:ok)
    end

    context 'with loan' do
      let(:loan) { Loan.create!(funded_amount: 100.0) }

      it 'should render the outstanding balance' do
        expected_loan = loan
        get :index
        expect(response.body).to include_json(
          [
          id: expected_loan.id,
          outstanding_balance: "100.0",
          ]
        )
      end
    end

    context 'with loan and payments' do
      let(:loan) {
        l = Loan.create!(funded_amount: 100.0)
        l.payments << Payment.create!(loan: l, payment_amount: 10.0, payment_date: "2017-01-01")
        l.payments << Payment.create!(loan: l, payment_amount: 10.0, payment_date: "2017-02-01")
        l
      }

      it 'should render the outstanding balance' do
        expected_loan = loan
        get :index

        expect(response.body).to include_json(
          [
          id: expected_loan.id,
          outstanding_balance: "80.0",
          ]
        )
      end
    end
  end

  describe '#show' do
    let(:loan) { Loan.create!(funded_amount: 100.0) }

    it 'responds with a 200' do
      get :show, id: loan.id
      expect(response).to have_http_status(:ok)
    end

    it 'should render the outstanding balance' do
      get :show, id: loan.id
      expect(response.body).to include_json(
        id: loan.id,
        outstanding_balance: "100.0",
      )
    end

    context 'if the loan is not found' do
      it 'responds with a 404' do
        get :show, id: 10000
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
