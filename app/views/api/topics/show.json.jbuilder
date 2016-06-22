if @errors
  json.errors @errors
else
  json.questions @topic.questions.includes(:comments,:answers).order(published_at: :desc).take(5) do |question|
    json.id question.id
    json.title question.title
    json.published_at question.published_at
    json.question_comments question.comments do |comment|
      json.comment comment.comment
    end
    json.answers question.answers do |answer|
      json.content answer.content
      json.answer_comments answer.comments do |comment|
        json.comment comment.comment
      end
    end 
  end
end