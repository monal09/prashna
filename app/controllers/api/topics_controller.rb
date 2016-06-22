class Api::TopicsController < ApplicationController

  before_action :set_topic
  before_action :find_ip
  before_action :check_for_request_limit

  def show
    Iprecord.create!(ip_address: @ip)
  end

  private

  def set_topic
    @topic = Topic.find_by(name: params[:id])
    @errors = "No such topic exists." unless @topic
  end

  def find_ip
    @ip = request.remote_ip
  end

  def check_for_request_limit
    if Iprecord.ip_requests(@ip).size > CONSTANTS["api_request_per_hour"]
      @errors ||= "Your limit for requests has been reached. Please try again later in next hour."
    end
  end

end
