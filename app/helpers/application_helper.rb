module ApplicationHelper

  def get_notification_message(user_notification)
    notification = user_notification.notification
    if notification.notifiable_type == "Question"
      question = notification.notifiable
      "#{link_to ('A new question <b>' + question.title + '</b> has been posted by <b>' + question.user.first_name + "</b>").html_safe, question_path(question) }".html_safe
    end
  end

end
