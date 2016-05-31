module PermissionHelper
  extend ActiveSupport::Concern

  private

  def can_edit_question?( question, user )
    (question.user == user) || is_admin?(user)
  end

  def can_view_question?( question, user )
    question.published? || (question.draft? && question.user == user) || is_admin?(user)
  end

  def is_admin?(user)
    user && user.admin?
  end

end
