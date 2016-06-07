class CreditTransactionsController < ApplicationController
 before_action :authenticate
 
 def index
   @credit_transactions = current_user.credit_transactions.includes(:resource).order(created_at: :desc)
 end

end

