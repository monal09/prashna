if @abuse_report.persisted?
  json.status "success"
else
  json.status "failure"
 end
