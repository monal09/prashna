if @downvote.persisted?
  json.status "success"
  json.upvote_count @answer.upvotes
  json.downvote_count @answer.downvotes
else
  json.status "failure"
  json.errors @downvote.errors.full_messages
end