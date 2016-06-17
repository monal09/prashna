class CreateAbuseReports < ActiveRecord::Migration
  def change
    create_table :abuse_reports do |t|
      t.references :abuse_reportable, polymorphic: true, index: {name: "abuse_reportable_id_type"}
      t.references :user, index: true
      t.timestamps null: false
    end
  end
end
