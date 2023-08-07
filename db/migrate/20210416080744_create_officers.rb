class CreateOfficers < ActiveRecord::Migration[6.0]
  def change
    create_table :officers do |t|
      t.string :name, limit: 255, default: ""
      t.datetime :date_of_birth
      t.boolean :gender, default: 1
      t.string :home_town, limit: 255, default: ""
      t.string :nationality, limit: 50, default: ""
      t.string :language_support, limit: 50, default: ""
      t.boolean :online, default: 0
      t.integer :status, default: 1
      t.timestamps
    end
  end
end
