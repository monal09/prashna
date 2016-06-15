if @questions.present?
  json.newQuestions @questions.size
  json.lastQuestionTime @questions.order(published_at: :desc).first.published_at.to_i
else
  json.newQuestions 0
end