class QuestionPublishabilityValidator < ActiveModel::Validator
  def validate(record)
    if record.question.draft?
      record.errors[:base] << "Question is in draft state and hence can not be published"
    end
  end
end
