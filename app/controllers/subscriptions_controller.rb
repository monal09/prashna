class SubscriptionsController < ApplicationController
  def create
    # session[:subscription] = JSON.dump(params.fetch(:subscription, {}))
    subscription_params = JSON.dump(params.fetch(:subscription, {}))
    sp = JSON.parse(subscription_params)
    authorization_key = sp["keys"]["auth"]
    user_id = session[:user_id]
    debugger
    # subscription_params[:]
    head :ok

  end
end