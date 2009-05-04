class PhotosController < ApplicationController
  session :cookie_only => false, :only => :create

  def index
    @photos = current_user.photos.latest
    respond_to do |format|
      format.html
      format.json  { render :json => @photos.to_json_for_gallery  }
    end
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    if current_user.photos.maxed?
      render :json => {
        :success => false,
        :msg => "You have reached the maximum allowed photos (#{MAX_PHOTOS}).  Please delete some photos if you want to upload new ones."
      }
    else 
      @photo = current_user.photos.build(:uploaded_data => params[:Filedata])
      if @photo.save     
        if current_user.n_photos == 1
          current_user.default_photo_id = @photo.id
          current_user.save!
        end
        render :json => @photo.to_json_for_gallery.merge!({:success => true})
      else 
        render :json => { 
          :success => false,
          :msg => @photo.errors.full_messages
        }
      end
    end
  end
  
  def assign_default
    photo = current_user.photos.find(params[:id])
    if photo
      current_user.default_photo_id = photo.id
      current_user.save!
      render :json => {
        :success => true,
        :msg => 'This is now your default photo'
      }
    else 
      render :json => {
        :success => false,
        :msg => 'There was a problem setting this photo as your default.  Please try again later.'
      }
    end 
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    
    if @photo 
      photo_id = @photo.id
      @photo.destroy
      if photo_id == current_user.default_photo_id
        current_user.reassign_default_photo
        current_user.save!
      end
      
      respond_to do |format|
        format.json {
          render :json => {}, :status => 200
        }
      end
    end
  end
end
