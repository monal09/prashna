# == Schema Information
#
# Table name: credits
#
#  id         :integer          not null, primary key
#  amount     :integer          not null
#  price      :decimal(10, )    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#FIXME_AB: change name to CreditPack 
class Credit < ActiveRecord::Base
	#FIXME_AB: add validations; done
	validates :amount, :price, presence: true
end
