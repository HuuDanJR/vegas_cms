class ChangeColumnTokenFromOauthAccessTokens < ActiveRecord::Migration[6.0]
  def up
    change_column :oauth_access_tokens, :token, :string, null: false, limit: 500
  end

  def down
    change_column :oauth_access_tokens, :token, :string, null: false, limit: 255
  end
end
