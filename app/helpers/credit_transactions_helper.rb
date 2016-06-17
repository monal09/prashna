module CreditTransactionsHelper
 
  def get_transaction_message(credit_transaction)

    if credit_transaction.event == "signup"
      "#{ credit_transaction.points } credits added for #{ credit_transaction.event }"
    elsif credit_transaction.event == "ask_question"
      "#{ pluralize(credit_transaction.points.abs, 'point') } debited for asking question: .
    	#{link_to credit_transaction.resource.title, credit_transaction.resource rescue "-"} ".html_safe
    elsif credit_transaction.event == "answer_question"
      "#{ credit_transaction.points.abs } point #{ credit_transaction.points > 0 ? "credited" : "debited"} for your answer on question: .
      #{link_to credit_transaction.resource.question.title, question_path(credit_transaction.resource.question) rescue "-"} ".html_safe
    elsif credit_transaction.event == "buy"
      " #{ pluralize(credit_transaction.points, 'point') } credited for your purchase of $ #{ credit_transaction.resource.price} credit pack"
    elsif credit_transaction.event == "answer_marked_abuse"
      "#{ credit_transaction.points.abs } point #{ credit_transaction.points > 0 ? "credited" : "debited"} as your answer on question: .
      #{link_to credit_transaction.resource.question.title, question_path(credit_transaction.resource.question) rescue "-"} has been marked offensive".html_safe
    end
  end

end
