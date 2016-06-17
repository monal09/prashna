# == Schema Information
#
# Table name: abuse_reports
#
#  id                    :integer          not null, primary key
#  abuse_reportable_id   :integer
#  abuse_reportable_type :string(255)
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  abuse_reportable_id_type        (abuse_reportable_type,abuse_reportable_id)
#  index_abuse_reports_on_user_id  (user_id)
#

class AbuseReport < ActiveRecord::Base

  validates :user, presence: true

  belongs_to :abuse_reportable, polymorphic: true
  belongs_to :user

  before_save :check_for_duplicate_existence
  after_save :update_abuse_reports_count
  after_save :update_reportable_count
  after_save :revert_credit_if_necessary

  private

  def update_abuse_reports_count
    debugger
    abuse_reportable.abuse_reports_count += 1
    abuse_reportable.save
  end

  def check_for_duplicate_existence
    if abuse_reportable.abuse_reports.where(user_id: user.id).first
      errors[:base] = "already reported"
      return false
    end
  end

  def update_reportable_count
    if abuse_reportable_type == "Answer"
      abuse_reportable.question.answers_count -= 1
      abuse_reportable.question.save!
    elsif abuse_reportable_type == "Comment"
      abuse_reportable.commentable.comments_count -= 1
      abuse_reportable.commentable.save!
    end
  end

  def revert_credit_if_necessary
    if credit_reversal_needed?
      abuse_reportable.user.credit_transactions.answer_marked_abuse.create!(points: -1 * CONSTANTS["credit_for_good_answers"], resource_id: abuse_reportable.id, resource_type: abuse_reportable.class )
    end
  end

  def credit_reversal_needed?
    abuse_reportable_type == "Answer" && abuse_reportable.is_credited_answer?
  end




end
