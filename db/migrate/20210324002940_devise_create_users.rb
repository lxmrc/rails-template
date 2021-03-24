# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username,           null: false
      t.string :email,              null: false
      t.string :encrypted_password, null: false

      t.datetime :remember_created_at

      t.timestamps null: false
    end
    add_index :users, :email,                unique: true
  end
end
