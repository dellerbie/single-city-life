class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :user_id,            :integer
      t.column :interested_in,      :string
      t.column :ethnicity,          :string
      t.column :best_feature,       :string
      t.column :body_type,          :string
      t.column :loves_when,         :string
      t.column :hates_when,         :string
      t.column :turn_ons,           :string
      t.column :turn_offs,          :string
      t.column :msg_me_if,          :string
      t.column :completed,         :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
