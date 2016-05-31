module CreditTransactionsHelper

  def get_transaction_message(credit_transaction)
    if credit_transaction.event == "signup"
      credit_transaction.amount.to_s + " credits added for " + credit_transaction.event
    elsif credit_transaction.event == "ask_question"
    	"#{pluralize(credit_transaction.amount.abs, 'point')} debited for asking question: .
    	#{link_to credit_transaction.resource.title, credit_transaction.resource rescue "-"} ".html_safe
    end
  end

end
