# == Schema Information
#
# Table name: push_notification_tokens
#
#  id         :integer          not null, primary key
#  auth_token :string(255)      not null
#  p256dh     :string(255)      not null
#  endpoint   :text(65535)      not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_push_notification_tokens_on_auth_token  (auth_token)
#  index_push_notification_tokens_on_p256dh      (p256dh)
#  index_push_notification_tokens_on_user_id     (user_id)
#

class PushNotificationToken < ActiveRecord::Base
  belongs_to :user
end
