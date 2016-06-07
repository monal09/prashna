# == Schema Information
#
# Table name: votes
#
#  id           :integer          not null, primary key
#  votable_id   :integer
#  votable_type :string(255)
#  upvote       :boolean          not null
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_votes_on_user_id                      (user_id)
#  index_votes_on_votable_type_and_votable_id  (votable_type,votable_id)
#

class Vote < ActiveRecord::Base

  belongs_to :votable, polymorphic: :true

  before_create :check_for_duplicate_existence
  after_save :update_vote_count

  scope :upvotes_count, -> {where(upvote: true)}
  scope :downvotes_count, -> {where(upvote: false)}

  private

  def update_vote_count
    votable.recalculate_vote_count!
  end

  def check_for_duplicate_existence
    vote = find_existing_vote

    if vote && vote.upvote? == self.upvote?
      return false
    elsif vote
      vote.destroy
    end
  end

  def find_existing_vote
    Vote.find_by(votable_id: votable_id, votable_type: votable_type, user_id: user_id)
  end

end
