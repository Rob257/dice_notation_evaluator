class CreateUserNotations < ActiveRecord::Migration
  def self.up
    create_table :user_notations do |t|
      t.string :notation
      t.string :result
      t.references :user_account

      t.timestamps
    end
  end

  def self.down
    drop_table :user_notations
  end
end

