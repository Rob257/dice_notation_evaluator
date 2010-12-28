class CreateAdminAccounts < ActiveRecord::Migration
  def self.up
    create_table :admin_accounts do |t|
      t.string :name
      t.string :hashed_password
      t.string :salt

      t.timestamps
    end
  end

  def self.down
    drop_table :admin_accounts
  end
end
