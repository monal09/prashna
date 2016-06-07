class UserPresenceValidator < ActiveModel::Validator
  def validate(record)
    if !(record.user)
      record.errors[:base] << "Each answer need to be associated with an user"
    end
  end
end
