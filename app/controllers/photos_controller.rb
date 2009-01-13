class PhotosController < ApplicationController

  session :cookie_only => false, :only => :create
  before_filter :login_required, :except => :create

  def index
    @photos = current_user.photos.latest
  end

  def show
    @photo = current_user.photos.find(params[:id])
  end

  def new
    @photo = Photo.new
  end

  def create
    @photo = current_user.photos.build(:uploaded_data => params[:Filedata])
    
    if @photo.save
      render :json => {
        :src => @photo.public_filename(:thumb),
        :edit_url => edit_user_photo_path(current_user, @photo)
      }.to_json
    else 
      # should render an error response?
      render :text => "There was an error uploading your photo.  Please try again later."
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    @photo.destroy
    redirect_to photos_url
  end
end
