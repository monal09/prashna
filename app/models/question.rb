# == Schema Information
#
# Table name: questions
#
#  id               :integer          not null, primary key
#  title            :string(255)      not null
#  content          :text(65535)      not null
#  pdf_name         :string(255)
#  user_id          :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  published        :boolean          default(FALSE)
#  slug             :string(255)
#  answers_count    :integer
#  pdf_file_name    :string(255)
#  pdf_content_type :string(255)
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  published_at     :datetime
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
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] },
    size: { in: 0..2.megabytes}
  #FIXME_AB: attachment max 2 MB, show hint to user also; done


  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :resource
  has_many :answers, dependent: :destroy, inverse_of: :question
  has_many :comments, dependent: :destroy, as: :commentable
  belongs_to :user

  after_save :deduct_credit_points_for_question
  after_save :add_topics
  before_save :ensure_sufficient_credit_balance, if: :is_to_be_published?
  before_save :update_published_at, if: :is_to_be_published?

  scope :published, -> { where(published: true) }
  scope :search, ->(query) { published.where("lower(title) LIKE ?", "%#{query.downcase}%")}
  scope :published_after_reload, ->(time) { published.where( "published_at > ?", Time.at(time.to_i) + 1)}

  def is_to_be_published?
    published? && !published_was
  end

  def to_param
    id.to_s + slugify_title
  end

  #FIXME_AB: remove all code related to manual file upload ; done

  def draft?
    !published?
  end

  def get_topics_list(question_params)
    if question_params && question_params[:associated_topics]
      return question_params[:associated_topics]
    end
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


  private

  def set_path
    self.pdf_name = uploaded_file.original_filename.to_s
  end

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

end
