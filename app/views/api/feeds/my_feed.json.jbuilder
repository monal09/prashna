if @user
json.topics @topics do |topic|
  json.id topic.id
  json.name topic.name
  json.questions topic.questions do |question|
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
else
  json.errors "No such user exists."
end