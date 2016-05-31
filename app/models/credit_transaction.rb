class CreditTransaction < ActiveRecord::Base

  enum event: [ :ask_question, :signup, :answer_question, :buy]

  belongs_to :user
  belongs_to :resource, polymorphic: true

  after_create :update_users_credit_balance

  scope :new_question, -> { where( event: :ask_question ) }
  scope :signup, -> {where( event: :signup )}
  scope :answer_question, -> { where( event: :answer_question ) }
  scope :buy_credit_points, -> { where( event: :buy ) } 
  
  private

  def update_users_credit_balance
    user.credit_balance += amount
    user.save
  end

end
