if @updates
  json.status "success"
else
  json.status "failure"
end