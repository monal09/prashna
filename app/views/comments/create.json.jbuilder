if @comment.persisted?
  json.status "success"
  json.comment simple_format(@comment.comment).html_safe
  json.commentable_type @comment.commentable_type
  json.commentable_id @comment.commentable_id
  json.user_name @comment.user.first_name
  json.comment_display render partial: "comments/vote_link", locals: { comment: @comment}
else
  json.status "failure"
  json.errors @comment.errors.full_messages
end