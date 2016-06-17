class AbuseReportsController < ApplicationController


  def create
    @abuse_report = current_user.abuse_reports.build(get_abuse_report_params)
    @abuse_report.save
  end

  private

  def get_abuse_report_params
    { abuse_reportable_type: params[:abusable_type], abuse_reportable_id: params[:abusable_id]}
  end


end
