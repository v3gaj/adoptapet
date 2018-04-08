class PetsController < ApplicationController
  before_action :set_pet, only: [:show, :edit, :profile, :gallery, :update, :destroy, :delete]
  before_action :require_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :require_admin, only: [:requests]
  before_action :pet_owner_editor, only: [:edit, :update]
  before_action only: [:show] do
    pet_deleted(@pet)
  end
  # GET /pets
  # GET /pets.json
  def index
    
    @categories = Category.all.joins(:pets).where('(pets.owner_id IS NULL OR 
                                                   pets.id IN (?)) AND 
                                                   pets.deleted = ?', 
                                                   (Adoption.all.select(:pet_id).where('adoptions.status = ?', 'returned')),
                                                   false).uniq

    if params["data"].present? && (params['data']['category_id'].present? || params['data']['priority'].present? || params['data']['gender'].present?)
      category_id = params['data']['category_id']
      priority = params['data']['priority']
      gender = params['data']['gender']
      
      @pets = Pet.all.where('(pets.owner_id IS NULL OR 
                             pets.id IN (?)) AND 
                             pets.category_id LIKE ? AND 
                             pets.priority LIKE ? AND 
                             pets.gender LIKE ? AND 
                             pets.deleted = ?', 
                             (Adoption.all.select(:pet_id).where('adoptions.status = ?', 'returned')), 
                             "%"+category_id+"%", 
                             "%"+priority+"%", 
                             "%"+gender+"%", 
                             false).order(created_at: :desc)

      @pets.count < 1 ? @search_results = 0 : @search_results = @pets.count
      @pets = @pets.paginate(page: params[:page], per_page: 12)
    else
      @pets = Pet.all.where('(pets.owner_id IS NULL OR 
                             pets.id IN (?)) AND 
                             pets.deleted = ?', 
                             (Adoption.all.select(:pet_id).where('adoptions.status = ?', 'returned')), 
                             false).order(created_at: :desc)
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

      @pets = Pet.all.joins(:adoptions).where("pets.name LIKE ? AND 
                                               pets.category_id LIKE ? AND 
                                               pets.show = ? AND 
                                               adoptions.status = ?", 
                                               "%"+name+"%", 
                                               "%"+category_id+"%", 
                                               true, 
                                               'accepted').order("adoptions.updated_at desc").uniq
      @pets.count < 1 ? @search_results = 0 : @search_results = @pets.count
      @pets = @pets.paginate(page: params[:page], per_page: 12)
    else
      @pets = Pet.all.joins(:adoptions).where("pets.show = ? AND adoptions.status = ?", true, 'accepted').order("adoptions.updated_at desc").uniq
      @pets = @pets.paginate(page: params[:page], per_page: 12)
    end
  end

  # GET /pets/1
  # GET /pets/1.json
  def show
    @post = Post.new
    @adopters = @pet.users.joins(:adoptions).where("adoptions.status = ? ", 'created').uniq
    @posts = @pet.posts.all.order(created_at: :desc).limit(5)
    if current_user
      @owner = Pet.owner_admin(@pet, current_user)
    end
  end

  def profile
    @post = Post.new
    @posts = @pet.posts.all.order(created_at: :desc).limit(Post::POSTSPERREFRESH)
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
    @pet.editor = current_user
    @pet.show = true
    @pet.deleted = false
    respond_to do |format|
      if @pet.save
        MessageMailer.pet_created(@pet).deliver_now
        #post_id = facebook_create_post(@pet.name, @pet.description, pet_path(@pet))
        #@pet.facebook_id = post_id['id']
        @pet.update(@pet.attributes)
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
  def delete
    if Adoption.delete_pet(@pet, current_user) || Adoption.delete_by_admin(@pet, current_user)
      @pet.deleted = true
      respond_to do |format|
        if @pet.update(@pet.attributes)
          #facebook_delete_post(@pet.facebook_id)
          close_all_adoption_requests(@pet)
          format.html { redirect_to my_profile_path, notice: 'La información de la mascota se elimino exitosamente.' }
          format.json { render :show, status: :ok, location: @pet }
        else
          format.html { render :edit }
          format.json { render json: @pet.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_back fallback_location: my_profile_path, notice: 'Solo puedes eliminar tus mascotas si no las has entregado a un nuevo dueño'
    end
  end

  def destroy
    if Adoption.delete_pet(@pet, current_user) || Adoption.delete_by_admin(@pet, current_user)
      respond_to do |format|
        if @pet.destroy
          MessageMailer.pet_deleted(@pet).deliver_now
          format.html { redirect_to my_profile_path, notice: 'La información de la mascota se elimino exitosamente.' }
          format.json { head :no_content }
        else
          format.html { redirect_back fallback_location: pet_path(@pet) }
          flash[:danger] = "Esta mascota no se puede eliminar porque exiten solicitudes de adopción relacionadas a ella."
        end
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
      params.require(:pet).permit(:name, :photo, :category_id, :size, :deleted, :gender, :years, :province, :city ,:months, :priority, :show, :cover, :description, :user_id)
    end

    def close_all_adoption_requests(pet)
      adoptions = Adoption.where(pet_id: pet)
      adoptions.each do |adoption|
        if adoption.status != 'rejected'
          adoption.status = 'incomplete'
          MessageMailer.adoption_rejected(adoption).deliver_now
        end
        adoption.update(adoption.attributes)
      end
    end

    # def facebook_create_post(name, description, url)
    #   @graph = Koala::Facebook::API.new('EAACJL6ITFb8BAOyLZCC06ZCy51BFFqklFGWynIIk2tkTqLZALNtgxEEf3yXILGpuQYVGbhhh3Rri4lPTlYcNh5ZBYAuzMbIW8r7SxTyALRsWXsysoapUpdpoEX6lPAme6rD5FuVXYTvZBcsZAYG7wI0IDAbfaNn4GOjUkVuzcOiiriVTFrgSv8uAscPyyEMZAkYHIriMPkY0AZDZD')
    #   @graph.put_wall_post("Adopta esta mascota!", {
    #     link: "http://tripcustomizers.com/" + url
    #   })
    # end

    # def facebook_delete_post(id)
    #   @graph = Koala::Facebook::API.new('EAACJL6ITFb8BAOyLZCC06ZCy51BFFqklFGWynIIk2tkTqLZALNtgxEEf3yXILGpuQYVGbhhh3Rri4lPTlYcNh5ZBYAuzMbIW8r7SxTyALRsWXsysoapUpdpoEX6lPAme6rD5FuVXYTvZBcsZAYG7wI0IDAbfaNn4GOjUkVuzcOiiriVTFrgSv8uAscPyyEMZAkYHIriMPkY0AZDZD')
    #   @graph.delete_object(id)
    # end

    def pet_deleted(pet)
      if @pet.deleted == true
        flash[:danger] = "La mascota no existe."
        redirect_back fallback_location: my_profile_path
      end
    end

end