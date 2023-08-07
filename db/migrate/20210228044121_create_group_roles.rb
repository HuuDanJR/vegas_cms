class CreateGroupRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :group_roles do |t|
      t.references :group, null: false, foreign_key: true
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
