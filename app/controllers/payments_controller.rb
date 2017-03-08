class PaymentsController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: 'not_found', status: :not_found
  end

  def index
    render json: Payment.where(loan_id: params[:loan_id])
  end

  def show
    render json: Payment.find_by!(loan_id: params[:loan_id], id: params[:id])
  end

  def create
    loan = Loan.find(params[:loan_id])
    payment_amount = BigDecimal.new(params[:payment][:payment_amount].to_s)

    if payment_amount > loan.outstanding_balance()
      render json: {errors: [{:payment_amount => "Payment Amount is greater than the Outstanding Balance"}]}, status: :unprocessable_entity
    else
      payment = Payment.create!(
        loan_id: params[:loan_id],
        payment_amount: payment_amount,
        payment_date: params[:payment][:payment_date]
      )

      render json: payment
    end
  end
end
