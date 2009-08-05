class PhotosController < ApplicationController
  before_filter :login_required, :except => [:user_photos, :show]
  session :cookie_only => false, :only => :create

  def index
    respond_to do |format|
      format.html
    end
  end
  
  def for_user
    user = User.find_by_login params[:user_id]
    @photos = user ? user.photos.latest : []
    render :json => @photos.to_json_for_gallery
  end

  def show
    @user = User.find_by_login params[:user_id]
    @photo = @user.photos.find(params[:id])
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
