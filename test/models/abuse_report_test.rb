require 'test_helper'

class AbuseReportTest < ActiveSupport::TestCase

  test "should not save abuse report without valid user" do
    abuse_report = abuse_reports(:valid_abuse_report_2)
    abuse_report.user_id = nil
    assert_not abuse_report.save, "Save abuse report without title"
  end

  test "check abuse report belongs to user" do
    abuse_report = abuse_reports(:valid_abuse_report_2)
    association = abuse_report.association(:user)
    assert_equal(association.class, ActiveRecord::Associations::BelongsToAssociation, "abuse report belongs to user")
  end

  test "check abuse report belongs to abusable type" do
    abuse_report = abuse_reports(:valid_abuse_report_2)
    association = abuse_report.association(:abuse_reportable)
    assert_equal(association.class, ActiveRecord::Associations::BelongsToPolymorphicAssociation, "abuse report belongs to abusable type")
  end

  test "check for duplicate existence" do
    duplicate_abuse_report = users(:sufficient_balance_user).abuse_reports.new(abuse_reportable_id: 1, abuse_reportable_type: "Question")
    assert_not duplicate_abuse_report.save, "saved duplicate abuse report for the same user"
  end

  test "check update abuse reports count" do
    abuse_report = users(:sufficient_balance_user).abuse_reports.new(abuse_reportable_id: 2, abuse_reportable_type: "Question")
    assert_difference("abuse_report.abuse_reportable.abuse_reports_count") do
      abuse_report.save
    end
  end

  test "check if answer count is updated if threshold value is reached " do
    abuse_report = AbuseReport.new(abuse_reportable_id: 1, abuse_reportable_type: "Answer", user_id: 3)
    assert_difference("abuse_report.abuse_reportable.question.answers_count", difference = -1) do
      abuse_report.save
    end
  end

  test "check if comment count is updated if threshold value is reached " do
    abuse_report = AbuseReport.new(abuse_reportable_id: 1, abuse_reportable_type: "Comment", user_id: 3)
    assert_difference("abuse_report.abuse_reportable.commentable.comments_count", difference = -1) do
      abuse_report.save
    end
  end






end
