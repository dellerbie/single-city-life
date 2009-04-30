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
        render :json => @photo.to_json_for_gallery.merge!({:success => true})
      else 
        render :json => { 
          :success => false,
          :msg => @photo.errors.full_messages
        }
      end
    end
  end
  
  def create_avatar
    current_user.avatar = current_user.photos.find(params[:photo_id])
    if current_user.save
      render :json => {}
    else 
      render :text => '', :status => 500
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    
    @photo.destroy
    respond_to do |format|
      format.json {
        render :json => {}, :status => 200
      }
    end
  end
end
