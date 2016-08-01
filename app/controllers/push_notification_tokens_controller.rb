class PushNotificationTokensController < ApplicationController
  def create
    subscription_params = JSON.dump(params.fetch(:subscription, {}))
    sp = JSON.parse(subscription_params)
    auth = sp["keys"]["auth"]
    endpoint = sp["endpoint"]
    p256dh = sp["keys"]["p256dh"]
    push_notification = PushNotificationToken.find_or_create_by(auth_token: auth, p256dh: p256dh, endpoint: endpoint)
    if signed_in? && !push_notification.user
      push_notification.user = current_user
    elsif !signed_in? && push_notification.user
      push_notification.user_id = nil
    end
    push_notification.save
    head :ok
  end
end
