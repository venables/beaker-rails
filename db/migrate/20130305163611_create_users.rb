class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :authentication_token
      t.string :password_reset_token
      t.datetime :last_login_at

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :authentication_token, unique: true
    add_index :users, :password_reset_token, unique: true
  end
end
