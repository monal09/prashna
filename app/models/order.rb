# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  price         :float(24)
#  credit_amount :integer
#  status        :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#

class Order < ActiveRecord::Base

	enum status: [:pending, :processed]
	
	validates :credit_amount, :price, presence: true
	validates :user, presence: true

	#FIXME_AB: pending; done
	scope :pending, -> { where( status: :pending)}
	
	belongs_to :user
	#FIXME_AB: dependent?; done
	has_many :transactions, dependent: :destroy

	after_create :create_credit_transaction

	private

	def create_credit_transaction
    user.credit_transactions.buy_credit_points.create!(amount: credit_amount, resource_id: id, resource_type: self.class)
	end

	
end
