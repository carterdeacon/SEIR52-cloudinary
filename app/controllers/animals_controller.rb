class AnimalsController < ApplicationController
  def index
    @animals = Animal.all
  end

  def show
    @animal = Animal.find params[:id]
  end

  def new
    @animal = Animal.new
  end
  
  def create
    animal = Animal.new animal_params
    if params[:file].present?
      req = Cloudinary::Uploader.upload(params[:file])
      animal.image = req["public_id"]
    end
    # We're using update_attributes here because we don't want to make a PUT request 
    # (.update to update the attributes in animal_params, then .save to update the 
    # image)
    animal.update_attributes(animal_params)
    animal.save
    redirect_to animal_path(animal)
  end

  def edit
    @animal = Animal.find(params[:id])
  end
  
  def update
    animal = Animal.find(params[:id])
    # This is the magic stuff that will let us upload an image to Cloudinary when creating a new animal.
    # First, check to see if the user has attached an image for uploading
    if params[:file].present?
      # Then call Cloudinary's upload method, passing in the file in params
      req = Cloudinary::Uploader.upload(params[:file])
      # Using the public_id allows us to use Cloudinary's powerful image transformation methods.
      animal.image = req["public_id"]
    end
    animal.update_attributes(animal_params)
    animal.save
    redirect_to animal_path(animal)
  end

  private
  def animal_params
    # We don't whitelist the image, because the image is not passed to the controller in the animal object produced by the new/edit form.

    params.require(:animal).permit(:name)
  end
end
