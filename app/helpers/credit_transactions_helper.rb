module CreditTransactionsHelper
 
  def get_transaction_message(credit_transaction)

    if credit_transaction.event == "signup"
      "#{ credit_transaction.amount } credits added for #{ credit_transaction.event }"
    elsif credit_transaction.event == "ask_question"
      "#{ pluralize(credit_transaction.amount.abs, 'point') } debited for asking question: .
    	#{link_to credit_transaction.resource.title, credit_transaction.resource rescue "-"} ".html_safe
    elsif credit_transaction.event == "answer_question"
      "#{CONSTANTS[:credit_for_good_answers]} point #{ credit_transaction.amount > 0 ? "credited" : "debited"} for your answer on question: .
      #{link_to credit_transaction.resource.question.title, question_path(credit_transaction.resource.question) rescue "-"} ".html_safe
    end
  end

end
