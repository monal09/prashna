class ChargesController < ApplicationController

  before_action :authenticate
  before_action :set_credit

  def new
  end

  def create
    @order = current_user.orders.pending.build(price: @credit.price, credit_amount: @credit.amount )

    customer = Stripe::Customer.create(
      :email => current_user.email,
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @credit.price * 100,
      :description => "#{@credit.price} charged for buying credit pack",
      :currency    => 'usd'
    )

    if charge
      @transaction = @order.transactions.build(get_transaction_params(charge))
      @transaction.user = current_user
      @order.status = :processed
      if !@order.save
        Stripe::Refund.create(
          charge: charge.id
        )
      end
    end

  rescue Exception => e
    flash[:error] = e.message
    redirect_to new_credit_charge_path

  end

  private

  def set_credit
    @credit = Credit.find_by(id: params[:credit_id])
    if @credit.nil?
      redirect_to root_path, notice: "No such credit pack exist"
    end
  end

  def get_transaction_params(charge)
    transaction_params = {}
    transaction_params[:charge_id] = charge.id
    transaction_params[:stripe_token] = params[:stripeToken]
    transaction_params[:amount] = charge.amount
    transaction_params[:currency] = charge.currency
    transaction_params[:stripe_customer_id] = charge.customer
    transaction_params[:description] = charge.description
    transaction_params[:stripe_email] = params[:stripeEmail]
    transaction_params[:stripe_token_type] = params[:stripeTokenType]
    transaction_params
  end

end
