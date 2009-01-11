class PhotosController < ApplicationController
  
  before_filter :login_required, :except => :create
  
  session :cookie_only => false, :only => :create

  def index
    @photos = current_user.photos
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    # this sucks, swfupload + restful_authentication don't play nice together
    # currently there is no way to use current_user with swfupload
    # this can be a MAJOR security hole, as someone can just
    # forge the user_id in the request params....
    user = User.find_by_login(params[:user_id])
    @photo = user.photos.build(:uploaded_data => params[:Filedata])
    
    if @photo.save
      render :text => @photo.public_filename(:thumb)
    else 
      render :text => "There was an error uploading your photo.  Please try again later."
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    @photo.destroy
    redirect_to photos_url
  end
end
