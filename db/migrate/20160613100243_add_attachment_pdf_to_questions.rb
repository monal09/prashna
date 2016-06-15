class AddAttachmentPdfToQuestions < ActiveRecord::Migration
  def self.up
    change_table :questions do |t|
      t.attachment :pdf
    end
  end

  def self.down
    remove_attachment :questions, :pdf
  end
end
