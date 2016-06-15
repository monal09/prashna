# == Schema Information
#
# Table name: credits
#
#  id         :integer          not null, primary key
#  points     :integer          not null
#  price      :decimal(10, )    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#FIXME_AB: change name to CreditPack 
class Credit < ActiveRecord::Base
	#FIXME_AB: :amount => :points; done
	validates :points, :price, presence: true
	validates :points, :price,  numericality: {greater_than_or_equal_to: 0.01}

end
