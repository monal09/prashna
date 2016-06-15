if @upvote.persisted?
  json.status "success"
  json.upvote_count @comment.upvotes
  json.downvote_count @comment.downvotes
else
  json.status "failure"
  json.errors @upvote.errors.full_messages
end