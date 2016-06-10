# == Schema Information
#
# Table name: transactions
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  charge_id          :string(255)      not null
#  stripe_token       :string(255)      not null
#  amount             :decimal(10, )    not null
#  currency           :string(255)      not null
#  stripe_customer_id :string(255)      not null
#  description        :string(255)      not null
#  stripe_email       :string(255)      not null
#  stripe_token_type  :string(255)      not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  order_id           :integer
#
# Indexes
#
#  index_transactions_on_order_id  (order_id)
#  index_transactions_on_user_id   (user_id)
#

class Transaction < ActiveRecord::Base

	belongs_to :order
	belongs_to :user

  validates :charge_id, :stripe_token, :amount, :currency, :stripe_customer_id, presence: :true
  validates :stripe_email, :description, :stripe_token_type, presence: :true
    
end
