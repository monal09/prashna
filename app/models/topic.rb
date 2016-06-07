# == Schema Information
#
# Table name: topics
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_topics_on_name  (name)
#

class Topic < ActiveRecord::Base

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  has_and_belongs_to_many :questions

end
