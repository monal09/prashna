# == Schema Information
#
# Table name: questions
#
#  id                  :integer          not null, primary key
#  title               :string(255)      not null
#  content             :text(65535)      not null
#  pdf_name            :string(255)
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  published           :boolean          default(FALSE)
#  slug                :string(255)
#  answers_count       :integer          default(0)
#  pdf_file_name       :string(255)
#  pdf_content_type    :string(255)
#  pdf_file_size       :integer
#  pdf_updated_at      :datetime
#  published_at        :datetime
#  abuse_reports_count :integer          default(0)
#  comments_count      :integer          default(0)
#  admin_unpublished   :boolean          default(FALSE)
#
# Indexes
#
#  index_questions_on_title    (title)
#  index_questions_on_user_id  (user_id)
#

class Question < ActiveRecord::Base
  self.per_page = 4

  has_attached_file :pdf

  attr_accessor :associated_topics

  validates :title, presence: true, uniqueness: true
  validates :content, length: {minimum: 20}, presence: true
  validates :user, presence: true
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] },
    size: { in: 0..2.megabytes}
  validates_attachment_size :pdf, :less_than => 2.megabytes,
    :unless => Proc.new {|m| m[:pdf].nil?}

  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :resource
  has_many :answers, dependent: :restrict_with_error, inverse_of: :question
  has_many :comments, dependent: :restrict_with_error, as: :commentable
  has_many :abuse_reports, dependent: :destroy, as: :abuse_reportable
  has_many :notifications, dependent: :destroy, as: :notifiable
  belongs_to :user

  after_save :deduct_credit_points_for_question
  after_save :add_topics
  after_save :create_notification, if: :is_to_be_published?
  before_save :ensure_sufficient_credit_balance, if: :is_to_be_published?
  before_save :update_published_at, if: :is_to_be_published?

  scope :published, -> { where(published: true) }
  scope :search_question, ->(query) { published.where("lower(title) LIKE ?", "%#{query.downcase}%")}
  scope :search_question_with_topic, ->(query, topic_id) { published.joins(:topics).where("lower(title) LIKE ? AND topics.id = ?", "%#{query.downcase}%", topic_id)}
  scope :published_after, ->(time) { published.where( "published_at > ?", Time.at(time.to_i) + 1)}
  scope :unoffensive, -> { where( "abuse_reports_count < ?", CONSTANTS["abuse_reports_for_offensive_state"])}
  scope :admin_unpublished, -> { where(admin_unpublished: true)}
  scope :not_admin_unpublished, -> { where(admin_unpublished: false)}
  scope :visible, -> { published.unoffensive.not_admin_unpublished }
  scope :submitted_by, ->(follow_id) { where(user_id: follow_id)}


  def self.search_by_topic_and_title(time, topic_id, question_title)
    @questions = Question.published_after(time).search_question_with_topic(question_title, topic_id)
  end

  def self.search_by_topic(topic_id, time)
    @topic = Topic.find_by(id: topic_id)
    @questions = @topic.questions.published_after(time).unoffensive
  end

  def self.search_by_question(time, question_title)
    @questions = Question.published_after(time).search_question(question_title).unoffensive
  end

  def is_to_be_published?
    published? && !published_was
  end

  def to_param
    id.to_s + slugify_title
  end

  def draft?
    !published?
  end

  def get_topics_list()
    topics.map(&:name).join(',')
  end

  def publish
    self.published = true
    save
  end

  def unpublish
    self.published = false
    save
  end

  def not_offensive?
    abuse_reports_count < CONSTANTS["abuse_reports_for_offensive_state"]
  end

  def offensive?
    !not_offensive?
  end


  private

  def slugify_title
    '-' + title.gsub(/[^0-9A-Za-z]/, '-')
  end

  def deduct_credit_points_for_question
    if is_to_be_published?
      user.credit_transactions.new_question.create!(points: (-1 * CONSTANTS["credit_required_for_asking_question"]), resource_id: id, resource_type: self.class)
    end
  end

  def add_topics
    if associated_topics
      current_topics = associated_topics.split(',')
      self.topics = current_topics.map do |topic|
        Topic.find_or_create_by(name: topic.strip)
      end
    end
  end

  def ensure_sufficient_credit_balance
    if user.credit_balance < CONSTANTS["credit_required_for_asking_question"]
      errors[:base] = "Insufficient credit balance. Consider buying credits to pursue.
                       You require #{CONSTANTS['credit_required_for_asking_question']} credit point for asking question"
      false
    end
  end

  def update_published_at
    self.published_at = Time.current
  end

  def create_notification
    notifications.create!(event: "New question posted")
  end

end
