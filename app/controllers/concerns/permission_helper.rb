module PermissionHelper
  extend ActiveSupport::Concern

  included  do
    helper_method :can_edit_question?, :can_view_question?, :can_edit_user?
  end

  private

  def can_edit_question?( question, user )
    ((question.user == user) || is_admin?(user)) && (question.comments.blank? && question.answers.blank?) 
  end

  def can_edit_user?( user, current_user)
    user == current_user || is_admin?(user)
  end

  def can_view_question?( question, user )
    (question.not_offensive? && question.published?) || ((question.draft? || question.offensive?)  && question.user == user) || is_admin?(user)
  end

  def is_admin?(user)
    user && user.admin?
  end

end
