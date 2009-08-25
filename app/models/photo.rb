class Photo < ActiveRecord::Base
  belongs_to :user
  
  has_attachment    :storage        => :file_system,
                    :resize_to      => '640x480',
                    :thumbnails     => { :thumb => '160x120', :small => '110x90', :tiny => '50>' },
                    :max_size       => 3.megabytes,
                    :content_type   => :image,
                    :processor      => 'Rmagick'
                    
  validates_as_attachment
  
  named_scope :latest, :order => 'created_at DESC'
  
  def to_json_for_gallery
    json = {
      :id => self.id,
      :thumb => self.public_filename(:thumb),
      :tiny => self.public_filename(:tiny),
      :full => self.public_filename(),
      :title => self.filename
    }
  end
end
