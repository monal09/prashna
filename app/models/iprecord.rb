# == Schema Information
#
# Table name: iprecords
#
#  id         :integer          not null, primary key
#  ip_address :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_iprecords_on_ip_address  (ip_address)
#

class Iprecord < ActiveRecord::Base

  validates :ip_address, presence: true

  scope :ip_requests, ->(ip){ ip_requests_this_hour.where("ip_address = ? AND created_at ", ip)}
  scope :ip_requests_this_hour, ->{ where(created_at: Time.current.beginning_of_hour..Time.current.end_of_hour)}
end
