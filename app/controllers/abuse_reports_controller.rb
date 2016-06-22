class AbuseReportsController < ApplicationController

  before_action :authenticate
  before_action :set_resource

  def create

    @abuse_report = @resource.abuse_reports.build(user_id: current_user.id)
    if !@abuse_report.save
      errors[:base] = "Failed to mark abusive. try again later"
    end
  end

  private

  def get_abuse_report_params
    { abuse_reportable_type: params[:abusable_type], abuse_reportable_id: params[:abusable_id]}
  end

  def set_resource
    if params[:abusable_type] == 'Question'
      @resource = Question.published.find_by(id: params[:abusable_id])
    elsif params[:abusable_type] == 'Answer'
      @resource = Answer.find_by(id: params[:abusable_id])
    elsif params[:abusable_type] == 'Comment'
      @resource = Comment.find_by(id: params[:abusable_id])
    end

    redirect_to root_path, notice: "The resource your are trying to mark offensive either doesn't
      exist or can't be marked offensive" unless @resource
  end


end
