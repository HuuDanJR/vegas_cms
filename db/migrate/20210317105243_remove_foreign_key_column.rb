class RemoveForeignKeyColumn < ActiveRecord::Migration[6.0]
  def up
    remove_foreign_key :group_roles, :groups
    remove_foreign_key :group_roles, :roles
    remove_foreign_key :user_groups, :users
    remove_foreign_key :user_groups, :groups
  end

  def down
    add_foreign_key :group_roles, :groups
    add_foreign_key :group_roles, :roles
    add_foreign_key :user_groups, :users
    add_foreign_key :user_groups, :groups
  end
end