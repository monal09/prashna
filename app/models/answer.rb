# == Schema Information
#
# Table name: answers
#
#  id          :integer          not null, primary key
#  content     :string(255)
#  user_id     :integer
#  question_id :integer
#  upvotes     :integer          default(0)
#  downvotes   :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#  index_answers_on_user_id      (user_id)
#

class Answer < ActiveRecord::Base
  validates :content, presence: true, length: {minimum: 10}
  validates_with UserPresenceValidator
  validates_with QuestionPublishabilityValidator

  after_save :reward_credits
  #FIXME_AB: dependent? restrict; done
  has_many :votes, as: :votable, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  belongs_to :question, counter_cache: true
  belongs_to :user

  def recalculate_vote_count!
    self.upvotes = votes.upvotes_count.size
    self.downvotes = votes.downvotes_count.size
    save!
  end

  private

  def reward_credits
    net_vote = upvotes - downvotes
    previous_upvotes  = get_previous_value(:upvotes)
    previous_downvotes = get_previous_value(:downvotes)
    net_vote_was = previous_upvotes - previous_downvotes
    if net_vote >= CONSTANTS["net_votes_for_credit"] && net_vote_was < CONSTANTS["net_votes_for_credit"]
      user.credit_transactions.answer_question.create!(amount: CONSTANTS["credit_for_good_answers"], resource_id: id, resource_type: self.class)
    elsif net_vote < CONSTANTS["net_votes_for_credit"] && net_vote_was >= CONSTANTS["net_votes_for_credit"]
      user.credit_transactions.answer_question.create!(amount: -1 * CONSTANTS["credit_for_good_answers"], resource_id: id, resource_type: self.class)
    end
  end

  def get_previous_value(type)
    if previous_changes[type]
      previous_votes = previous_changes[type].first
    else
      if type.to_s == "upvotes"
        previous_votes = upvotes
      else
        previous_votes = downvotes
      end
    end
    previous_votes
  end


end
