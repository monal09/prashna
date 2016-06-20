# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer          not null
#  followed_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_relationships_on_followed_id  (followed_id)
#  index_relationships_on_follower_id  (follower_id)
#

class Relationship < ActiveRecord::Base
  validates :follower_id, presence: true
  validates :followed_id, presence: true
  validates_with CanNotFollowYourselfValidator


  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  def questions_by_followed_people
    @questions = User.find_by(id: followed_id).questions.unoffensive
  end


end
