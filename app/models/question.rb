# == Schema Information
#
# Table name: questions
#
#  id            :integer          not null, primary key
#  title         :string(255)      not null
#  content       :text(65535)      not null
#  pdf_name      :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  published     :boolean          default(FALSE)
#  slug          :string(255)
#  answers_count :integer
#
# Indexes
#
#  index_questions_on_title    (title)
#  index_questions_on_user_id  (user_id)
#

class Question < ActiveRecord::Base

  attr_accessor :uploaded_file
  attr_accessor :associated_topics

  validates :title, presence: true, uniqueness: true
  validates :content, length: {minimum: 20}, presence: true

  has_and_belongs_to_many :topics
  has_many :credit_transactions, as: :resource
  has_many :answers, dependent: :destroy, inverse_of: :question
  belongs_to :user
  accepts_nested_attributes_for :answers

  after_save :deduct_credit_points_for_question
  after_save :add_topics
  #FIXME_AB: we need to remove this after integrating paperclip
  before_create :set_path, if: "uploaded_file.present?"
  after_create :save_file, if: "uploaded_file.present?"
  before_save :ensure_sufficient_credit_balance, if: :is_to_be_published?

  scope :published, -> { where(published: true) }
  scope :search, ->(query) { published.where("lower(title) LIKE ?", "%#{query.downcase}%")}

  self.per_page = 4

  def is_to_be_published?
    published? && !published_was
  end

  def to_param
    id.to_s + slugify_title
  end

  def get_target
    Rails.root.join('public','uploads','question_pdf',id.to_s)
  end

  def draft?
    !published?
  end

  def get_topics_list
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

  def save_file
    ensure_upload_dir
    write_file
  end

  def write_file
    target_file = get_target + self.pdf_name

    File.open(target_file, 'wb') do |file|
      file.write(uploaded_file.read)
    end

  end

  def ensure_upload_dir
    FileUtils.mkdir_p(get_target)
  end


  def delete_file
    FileUtils.remove_dir(get_target)
  end

  def slugify_title
    '-' + title.gsub(/[^0-9A-Za-z]/, '-')
  end

  def deduct_credit_points_for_question
    if is_to_be_published?
      user.credit_transactions.new_question.create!(amount: (-1 * CONSTANTS["credit_required_for_asking_question"]), resource_id: id, resource_type: self.class)
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

end
