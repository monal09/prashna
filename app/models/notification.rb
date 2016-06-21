# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  notifiable_id   :integer          not null
#  notifiable_type :string(255)      not null
#  event           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notifications_on_notifiable_type_and_notifiable_id  (notifiable_type,notifiable_id)
#

class Notification < ActiveRecord::Base

  belongs_to :notifiable, polymorphic: true
  has_many :user_notifications, dependent: :destroy

  after_save :create_user_notifications

  private

  def create_user_notifications
    if notifiable_type == "Question"
      topics = Topic.joins(:questions).where("questions.id = ?", notifiable_id)
      topics.each do |topic|
        topic.users.each do |user|
          user_notification = UserNotification.find_or_create_by!(notification_id: id)
          user_notification.user = user
          user_notification.save
        end
      end
    end
  end

end
