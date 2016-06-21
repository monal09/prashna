# == Schema Information
#
# Table name: user_notifications
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  notification_id :integer
#  read            :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_notifications_on_notification_id  (notification_id)
#  index_user_notifications_on_user_id          (user_id)
#

class UserNotification < ActiveRecord::Base
  belongs_to :user
  belongs_to :notification

  scope :unread, -> { where(read: false)}
end
