class CreditTransaction < ActiveRecord::Base
  belongs_to :user
  enum event: [ :ask_question, :signup, :answer_question, :buy]

  after_create :update_total_credits

  private

  def update_total_credits
    user.total_credits += amount
  end

end
