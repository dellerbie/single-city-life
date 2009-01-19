class PhotosController < ApplicationController

  session :cookie_only => false, :only => :create
  before_filter :login_required, :except => :create

  def index
    @photos = current_user.photos.latest
    
    respond_to do |format|
      format.html
      format.json  { 
        json = {}
        json[:photos] = @photos.collect do |photo|
          {
            :id => photo.id,
            :thumb => photo.public_filename(:thumb),
            :tiny => photo.public_filename(:tiny),
            :full => photo.public_filename()
          }
        end
        render :json => json.to_json
      }
    end
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
        :thumb => @photo.public_filename(:thumb),
        :tiny => @photo.public_filename(:tiny),
        :full => @photo.public_filename(),
        :id => @photo.id,
        :success => true
      }.to_json
    else 
      render :json => { 
        :success => false,
        :msg => @photo.errors.full_messages
      }.to_json
    end
  end

  def destroy
    @photo = current_user.photos.find(params[:id])
    @photo.destroy
    
    respond_to do |format|
      format.html {
        redirect_to user_photos_path(current_user)
      }
      
      format.json {
        render :json => {
          :success => true
        }
      }
    end
  end
end
