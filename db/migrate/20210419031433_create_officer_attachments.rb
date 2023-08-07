class CreateOfficerAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :officer_attachments do |t|
      t.references :officer, null: false
      t.references :attachment, null: false

      t.timestamps
    end
  end
end
