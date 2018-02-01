class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :profile, :gallery, :update, :destroy]
  before_action :require_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_admin, only: [:requests]
  before_action :pet_owner_editor, only: [:edit, :update]
  # GET /pets
  # GET /pets.json
  def index
    #@pets = Pet.all.find_by_sql ["SELECT * FROM pets WHERE id NOT IN (SELECT pet_id FROM adoptions WHERE status <> 'created' AND status <> 'returned') OR id IN (SELECT pet_id FROM adoptions WHERE status = 'rejected' AND pet_id NOT IN (SELECT pet_id FROM adoptions WHERE status IN ('accepted', 'returned'))) ORDER BY created_at DESC"]
    
    if params["data"].present? && (params['data']['category_id'].present? || params['data']['priority'].present? || params['data']['gender'].present?)
      category_id = params['data']['category_id']
      priority = params['data']['priority']
      gender = params['data']['gender']

      @pets = Pet.all.where('(pets.category_id LIKE ? AND pets.priority LIKE ? AND pets.gender LIKE ?) AND (pets.id NOT IN (?) or pets.id IN (?))', "%"+category_id+"%", "%"+priority+"%", "%"+gender+"%", (Adoption.all.select(:pet_id).where("adoptions.status <> ? AND adoptions.status <> ?", 'created', 'returned')), 
          (Adoption.all.select(:pet_id).where("adoptions.status = ? AND adoptions.pet_id NOT IN (?)", 'rejected', (Adoption.all.select(:pet_id).where("adoptions.status = ? OR adoptions.status = ?", 'accepted', 'returned'))))).order(created_at: :desc)
      @pets.count < 1 ? @search_results = 0 : @search_results = @pets.count
      @pets = @pets.paginate(page: params[:page], per_page: 12)
    else
      @pets = Pet.all.where('pets.id NOT IN (?) or pets.id IN (?)', (Adoption.all.select(:pet_id).where("adoptions.status <> ? AND adoptions.status <> ?", 'created', 'returned')), 
            (Adoption.all.select(:pet_id).where("adoptions.status = ? AND adoptions.pet_id NOT IN (?)", 'rejected', (Adoption.all.select(:pet_id).where("adoptions.status = ? OR adoptions.status = ?", 'accepted', 'returned'))))).order(created_at: :desc)
      @pets = @pets.paginate(page: params[:page], per_page: 12)
    end

  end

  def requests
    @pets = Pet.all.joins(:adoptions).where("adoptions.status = ?", 'created').uniq.paginate(page: params[:page], per_page: 12)
  end

  def adoptions

    if params["data"].present? && (params['data']['name'].present? || params['data']['category_id'].present?)
      name = params['data']['name']
      category_id = params['data']['category_id']

      @pets = Pet.all.joins(:adoptions).where("pets.name LIKE ? AND pets.category_id LIKE ? AND pets.show = ? AND adoptions.status = ?", "%"+name+"%", "%"+category_id+"%", true, 'accepted').order("adoptions.updated_at desc").uniq
      @pets.count < 1 ? @search_results = 0 : @search_results = @pets.count
      @pets = @pets
    else
      @pets = Pet.all.joins(:adoptions).where("pets.show = ? AND adoptions.status = ?", true, 'accepted').order("adoptions.updated_at desc").uniq
      @pets = @pets.paginate(page: params[:page], per_page: 12)
    end
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
    @adopters = @pet.users.joins(:adoptions).where("adoptions.status = ? ", 'created').uniq
    @posts = @pet.posts.all.order(created_at: :desc)
    if current_user
      @owner = Pet.owner_admin(@pet, current_user)
    end
  end

  def profile
    @posts = @pet.posts.all.order(created_at: :desc)
    if current_user
      @owner = Pet.owner_admin(@pet, current_user)
    end
    respond_to do |format|
      format.js { render template: 'pets/profile'}
    end
  end

  def gallery
    @photo = Photo.new
    @photos = @pet.photos.all.order(created_at: :desc)
    respond_to do |format|
      format.js { render template: 'pets/gallery'}
    end
  end

  # GET /pets/new
  def new
    @pet = Pet.new
  end

  # GET /pets/1/edit
  def edit
  end

  # POST /pets
  # POST /pets.json
  def create
    @pet = Pet.new(pet_params)
    @pet.user = current_user
    @pet.show = true
    respond_to do |format|
      if @pet.save
        MessageMailer.pet_creation(@pet).deliver_now
        format.html { redirect_to @pet, notice: 'La mascota fue ingresada exitosamente.' }
        format.json { render :show, status: :created, location: @pet }
      else
        format.html { render :new }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pets/1
  # PATCH/PUT /pets/1.json
  def update
    respond_to do |format|
      if @pet.update(pet_params)
        format.html { redirect_to @pet, notice: 'La información de la mascota fue actualizada exitosamente.' }
        format.json { render :show, status: :ok, location: @pet }
      else
        format.html { render :edit }
        format.json { render json: @pet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pets/1
  # DELETE /pets/1.json
  def destroy
    if Adoption.delete_pet(@pet, current_user) || Adoption.delete_by_admin(@pet, current_user)
      @pet.destroy
      respond_to do |format|
        format.html { redirect_to my_profile_path, notice: 'La información de la mascota se elimino exitosamente.' }
        format.json { head :no_content }
      end
    else
      redirect_back fallback_location: my_profile_path, notice: 'Solo puedes eliminar tus mascotas si no las has entregado a un nuevo dueño'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pet_params
      params.require(:pet).permit(:name, :photo, :category_id, :color, :gender, :years, :province, :city ,:months, :priority, :show, :cover, :description, :user_id)
    end


end