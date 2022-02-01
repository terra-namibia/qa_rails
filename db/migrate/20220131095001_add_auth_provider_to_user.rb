class AddAuthProviderToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :auth_provider, :string
  end
end
