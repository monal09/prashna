# == Schema Information
#
# Table name: answers
#
#  id                  :integer          not null, primary key
#  content             :string(255)
#  user_id             :integer
#  question_id         :integer
#  upvotes             :integer          default(0)
#  downvotes           :integer          default(0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  abuse_reports_count :integer          default(0)
#  comments_count      :integer          default(0)
#  admin_unpublished   :boolean          default(FALSE)
#
# Indexes
#
#  index_answers_on_question_id  (question_id)
#  index_answers_on_user_id      (user_id)
#

class Answer < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  validates :content, presence: true, length: {minimum: 10}
  validates_with UserPresenceValidator
  validates_with QuestionPublishabilityValidator

  after_save :reward_credits
  after_commit :send_notification_mail, on: :create
  after_create :update_answers_count
  after_save :decrement_answer_count, if: :is_admin_unpublished?
  after_save :increment_answer_count, if: :is_admin_published?
  after_create :send_push_notification

  has_many :votes, as: :votable, dependent: :restrict_with_error
  has_many :comments, as: :commentable, dependent: :restrict_with_error
  has_many :abuse_reports, dependent: :destroy, as: :abuse_reportable
  belongs_to :question
  belongs_to :user

  scope :unoffensive, -> { where( "abuse_reports_count < ?", 1)}
  scope :admin_unpublished, -> { where(admin_unpublished: true)}
  scope :not_admin_unpublished, -> { where(admin_unpublished: false)}
  scope :visible, -> { unoffensive.not_admin_unpublished }

  def recalculate_vote_count!
    self.upvotes = votes.upvotes.size
    self.downvotes = votes.downvotes.size
    save!
  end

  def is_credited_answer?
    (upvotes - downvotes) >= CONSTANTS["net_votes_for_credit"]
  end

  private

  def is_admin_unpublished?
    admin_unpublished? && !admin_unpublished_was
  end

  def is_admin_published?
    !admin_unpublished? && admin_unpublished_was
  end

  def decrement_answer_count
    question.answers_count -= 1
    question.save
  end

  def increment_answer_count
    question.answers_count += 1
    question.save
  end

  def reward_credits
    net_vote = upvotes - downvotes
    previous_upvotes  = get_previous_value(:upvotes)
    previous_downvotes = get_previous_value(:downvotes)
    net_vote_was = previous_upvotes - previous_downvotes
    if net_vote >= CONSTANTS["net_votes_for_credit"] && net_vote_was < CONSTANTS["net_votes_for_credit"]
      user.credit_transactions.answer_question.create!(points: CONSTANTS["credit_for_good_answers"], resource_id: id, resource_type: self.class)
    elsif net_vote < CONSTANTS["net_votes_for_credit"] && net_vote_was >= CONSTANTS["net_votes_for_credit"]
      user.credit_transactions.answer_question.create!(points: -1 * CONSTANTS["credit_for_good_answers"], resource_id: id, resource_type: self.class)
    end
  end

  def get_previous_value(type)
    if changes[type]
      previous_votes = changes[type].first
    else
      if type.to_s == "upvotes"
        previous_votes = upvotes
      else
        previous_votes = downvotes
      end
    end
    previous_votes
  end

  def send_notification_mail
    UserNotifier.new_answer_posted(self).deliver_now
  end

  def update_answers_count
    question.answers_count += 1
    question.save!
  end

  def is_offensive?
    abuse_reports_count > 0
  end

  def check_offensive_status
    if is_offensive?
      errors[:base] = "Offensive answer can't be saved"
      return false
    end
  end

  def send_push_notification
    questioner = question.user
    questioner_subscriptions = questioner.push_notification_tokens
    message = {
      title: "New answer posted to your question.",
      body: content,
      url: question_path(self.question.id)
    }
    questioner_subscriptions.each do |subscription|
      webpush_params = { message: JSON.generate(message), endpoint: subscription.endpoint, p256dh: subscription.p256dh, auth: subscription.auth_token, api_key: "AIzaSyBMjNhhKsAAPt2vrGkqcG9LhxRPTJuDDfI" }
      Webpush.payload_send webpush_params
    end
  end


end
