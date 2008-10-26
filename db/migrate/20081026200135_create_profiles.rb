class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.column :user_id,      :integer
      t.column :ethnicity,    :string
      t.column :best_feature, :string
      t.column :loves_when,   :string
      t.column :hates_when,   :string
      t.column :thinks,       :string
      t.column :my_kinda,     :string
      t.column :turn_ons,     :string
      t.column :turn_offs,    :string
      t.column :msg_me_if,    :string
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
