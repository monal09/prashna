class CreditTransactionsController < ApplicationController
 
 def index
   @credit_transactions = current_user.credit_transactions
 end

end
