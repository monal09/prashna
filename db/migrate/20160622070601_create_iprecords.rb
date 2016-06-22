class CreateIprecords < ActiveRecord::Migration
  def change
    create_table :iprecords do |t|
      t.string :ip_address, null: false, index: true
      t.timestamps null: false
    end
  end
end
