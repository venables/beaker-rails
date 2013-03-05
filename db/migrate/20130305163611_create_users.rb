class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :authentication_token

      t.timestamps
    end

    add_index :users, :authentication_token, unique: true
  end
end
