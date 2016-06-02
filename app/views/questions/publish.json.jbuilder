if @published
  json.status "success"
else
  json.status "failure"
  json.errors @question.errors.full_messages
end