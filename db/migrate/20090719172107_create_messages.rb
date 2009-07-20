class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.integer :parent_id
      t.string :subject
      t.string :message
      t.boolean :read, :default => false
      t.integer :children_count

      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end
