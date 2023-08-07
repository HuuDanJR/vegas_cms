class CreateAttachments < ActiveRecord::Migration[6.0]
  def change
    create_table :attachments do |t|
      t.string :name, null: false, limit: 255
      t.string :file, null: false, limit: 255
      t.string :file_hash, null: false, limit: 255
      t.integer :category, default: 0
      t.timestamps
    end
  end
end
