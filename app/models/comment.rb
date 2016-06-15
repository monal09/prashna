# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  commentable_id   :integer
#  commentable_type :string(255)
#  comment          :text(65535)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  upvotes          :integer          default(0), not null
#  downvotes        :integer          default(0), not null
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ActiveRecord::Base

  validates :comment, :user, :commentable, presence: true

  has_many :votes, as: :votable, dependent: :restrict_with_error
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  def recalculate_vote_count!
    self.upvotes = votes.upvotes.size
    self.downvotes = votes.downvotes.size
    save!
  end

end
