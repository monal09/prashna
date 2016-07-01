# == Schema Information
#
# Table name: comments
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  commentable_id      :integer
#  commentable_type    :string(255)
#  comment             :text(65535)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  upvotes             :integer          default(0), not null
#  downvotes           :integer          default(0), not null
#  abuse_reports_count :integer          default(0)
#  admin_unpublished   :boolean          default(FALSE)
#
# Indexes
#
#  index_comments_on_commentable_type_and_commentable_id  (commentable_type,commentable_id)
#  index_comments_on_user_id                              (user_id)
#

class Comment < ActiveRecord::Base

  validates :comment, :user, :commentable, presence: true

  has_many :votes, as: :votable, dependent: :restrict_with_error
  has_many :abuse_reports, dependent: :destroy, as: :abuse_reportable

  belongs_to :commentable, polymorphic: true
  belongs_to :user
  after_create :update_comment_count
  after_save :decrement_comment_count, if: :is_admin_unpublished?
  after_save :increment_comment_count, if: :is_admin_published?

  scope :unoffensive, -> { where( "abuse_reports_count > ?", CONSTANTS["abuse_reports_for_offensive_state"])}
  scope :admin_unpublished, -> { where(admin_unpublished: true)}
  scope :not_admin_unpublished, -> { where(admin_unpublished: false)}
  scope :visible, -> { unoffensive.not_admin_unpublished }

  def recalculate_vote_count!
    self.upvotes = votes.upvotes.size
    self.downvotes = votes.downvotes.size
    save!
  end

  private

  def decrement_comment_count
    commentable.comments_count -= 1
    commentable.save
  end

  def increment_comment_count
    commentable.comments_count += 1
    commentable.save
  end

  def ensure_not_offensive?
    abuse_reports_count < 1
  end

  def check_offensive_status
    if is_offensive?
      errors[:base] = "Offensive answer can't be saved"
      return false
    end
  end

  def update_comment_count
    commentable.comments_count += 1
    commentable.save!
  end

  def is_admin_unpublished?
    admin_unpublished? && !admin_unpublished_was
  end

  def is_admin_published?
    !admin_unpublished? && admin_unpublished_was
  end

end
