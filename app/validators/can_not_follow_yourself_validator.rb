class CanNotFollowYourselfValidator < ActiveModel::Validator
  def validate(record)
    if record.followed_id == record.follower_id
      record.errors[:base] << "You can not follow yourself."
    end
  end
end

