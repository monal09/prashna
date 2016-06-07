if @upvote.persisted?
  json.status "success"
  json.upvote_count @answer.upvotes
  json.downvote_count @answer.downvotes
else
  json.status "failure"
  json.errors @answer.errors.full_messages
end