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
        unless current_user.default_photo_id
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
      if current_user.save
        render :json => {
          :success => true,
          :msg => 'Your default photo has been updated'
        }
      else 
        render :json => {
          :success => false,
          :msg => 'Could not set your default photo at this time.  Please try again later.'
        }
      end
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    deleted_photo_id = @photo.id
    @photo.destroy
    
    if current_user.default_photo_id == deleted_photo_id
      new_default_photo = current_user.photos.first
      current_user.default_photo_id = new_default_photo ? new_default_photo.id : nil
      current_user.save!
    end
    
    respond_to do |format|
      format.json {
        render :json => {
          :success => true,
          :msg => ''
        }
      }
    end
  end
end
