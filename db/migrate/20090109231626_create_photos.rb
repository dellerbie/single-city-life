class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.string :content_type
      t.string :filename
      t.string :path
      t.integer :parent_id
      t.string :thumbnail
      t.integer :size
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end
