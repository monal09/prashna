module PermissionHelper
  extend ActiveSupport::Concern

  included  do
    helper_method :can_edit_question?, :can_view_question?
  end

  private

  def can_edit_question?( question, user )
    (question.user == user) || is_admin?(user)
  end

  def can_view_question?( question, user )
    #FIXME_AB: admin and owner can see offensive question; done
    (question.not_offensive? && question.published?) || ((question.draft? || question.offensive?)  && question.user == user) || is_admin?(user)
  end

  def is_admin?(user)
    user && user.admin?
  end

end
