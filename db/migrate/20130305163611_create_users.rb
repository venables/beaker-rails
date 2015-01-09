class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users, id: :uuid do |t|
      t.string :email
      t.string :password_digest
      t.string :password_reset_token
      t.datetime :last_login_at

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :password_reset_token, unique: true
  end
end
