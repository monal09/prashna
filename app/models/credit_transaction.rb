# == Schema Information
#
# Table name: credit_transactions
#
#  id            :integer          not null, primary key
#  points        :float(24)        not null
#  user_id       :integer          not null
#  event         :integer
#  resource_id   :integer
#  resource_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_credit_transactions_on_user_id  (user_id)
#

class CreditTransaction < ActiveRecord::Base

  enum event: [ :ask_question, :signup, :answer_question, :buy, :answer_marked_abuse]

  belongs_to :user
  belongs_to :resource, polymorphic: true

  after_create :update_users_credit_balance

  scope :new_question, -> { where( event: :ask_question ) }
  scope :signup, -> {where( event: :signup )}
  scope :answer_question, -> { where( event: :answer_question ) }
  scope :buy_credit_points, -> { where( event: :buy ) } 
  scope :answer_marked_abuse, ->{ where( event: :answer_marked_abuse )}
  
  private

  def update_users_credit_balance
    user.credit_balance += points
    user.save
  end

end
