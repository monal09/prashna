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
#  index_relationships_on_followed_id                  (followed_id)
#  index_relationships_on_follower_id                  (follower_id)
#  index_relationships_on_follower_id_and_followed_id  (follower_id,followed_id) UNIQUE
#

#FIXME_AB: need one unique index; done
class Relationship < ActiveRecord::Base
  #FIXME_AB: validates follower followed, done
  validates :follower, :followed, presence: true
  validates_with CanNotFollowYourselfValidator

  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  #FIXME_AB: not needed here, can have in questions controller quesstions/by_followings; done
  
end
