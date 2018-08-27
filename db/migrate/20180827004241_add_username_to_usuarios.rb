class AddUsernameToUsuarios < ActiveRecord::Migration[5.2]
  def change
    add_column :usuarios, :username, :string
    add_column :usuarios, :first_name, :string
    add_column :usuarios, :last_name, :string
  end
end
