class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :login,                      :string, :limit => 15
      t.column :email,                      :string, :limit => 100
      t.column :crypted_password,           :string, :limit => 40
      t.column :salt,                       :string, :limit => 40
      t.column :created_at,                 :datetime
      t.column :updated_at,                 :datetime
      t.column :remember_token,             :string, :limit => 40
      t.column :remember_token_expires_at,  :datetime
      t.column :activation_code,            :string, :limit => 40
      t.column :activated_at,               :datetime
      t.column :password_reset_code,        :string, :limit => 40
      t.column :enabled,                    :boolean, :default => true
      t.column :birthdate,                  :date
      t.column :gender,                     :string
    end
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
