class PhotosController < ApplicationController
  before_action :set_photo, only: [:destroy]
  before_action :set_pet, only: [:new, :create, :destroy]
  before_action :require_user, only: [:new, :create, :destroy]
  before_action :pet_owner_editor, only: [:new, :create, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photo = Photo.new
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # POST /photos
  # POST /photos.json

  def create
    @photo = Photo.new()
    @errors = []
    @counter = 0

    params[:photos].each do |photo|
      if Photo.create(:pet_id => @pet.id, :photo => photo).valid?
        @counter += 1
      else
        begin
          Photo.create!(:pet_id => @pet.id, :photo => photo)
        rescue Exception => e
          error = {}
          error['image'] = photo.original_filename
          error['error'] = e.message.remove("Validation failed: ")
        end
        @errors.push(error)
      end
    end
    respond_to do |format|
      if @errors.count < 1
        format.html { redirect_to pet_path(@pet), notice: 'Las fotos se han incluido exitosamente.' }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @photos = @pet.photos.all.order(created_at: :desc)
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to @pet, notice: 'Las foto se ha eliminado exitosamente.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.where(slug: params[:pet_id]).first
    end

    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:photo, :title)
    end
end
