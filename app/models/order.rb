# == Schema Information
#
# Table name: orders
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  price         :float(24)
#  credit_points :integer
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

	validates :credit_points, :price, presence: true
  validates :credit_points, :price,  numericality: {greater_than_or_equal_to: 0.01}
	validates :user, presence: true

	scope :pending, -> { where( status: :pending)}

	belongs_to :user
	has_many :transactions, dependent: :destroy

	after_create :create_credit_transaction

	private

	def create_credit_transaction
    user.credit_transactions.buy_credit_points.create!(points: credit_points, resource_id: id, resource_type: self.class)
	end


end
