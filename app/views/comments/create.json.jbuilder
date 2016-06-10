if @comment.persisted?
  json.status "success"
  json.comment @comment.comment
  json.commentable_type @comment.commentable_type
  json.commentable_id @comment.commentable_id
  json.user_name @comment.user.first_name
else
  json.status "failure"
  json.errors @comment.errors.full_messages
end