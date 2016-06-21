class UserNotificationsController < ApplicationController
  
  def mark_read
    @updates = current_user.user_notifications.update_all(read: true)
  end

end
