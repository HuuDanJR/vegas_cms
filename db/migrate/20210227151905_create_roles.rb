class CreateRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :roles do |t|
      t.string :name, limit: 255
      t.string :description, limit: 255
      t.string :action, limit: 255
      t.string :resource, limit: 255
      t.timestamps
    end
  end
end
