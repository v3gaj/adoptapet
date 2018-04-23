class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_user, only: [:profile]
  before_action :require_admin, only: [:show, :destroy, :index]
  before_action :require_same_user, only: [:edit, :update]


  # GET /users
  # GET /users.json
  def index

    if params["data"].present? && (params['data']['email'].present? || params['data']['name'].present? || params['data']['lastName'].present?)
      email = params['data']['email']
      name = params['data']['name']
      lastName = params['data']['lastName']

      @users = User.all.where("email LIKE ? AND name LIKE ? AND lastName LIKE ?", "%"+email+"%", "%"+name+"%", "%"+lastName+"%").order("created_at desc")
      @users.count < 1 ? @search_results = 0 : @search_results = @users.count
    else
      @users = User.all
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    my_pets
    requests
    adoptions
  end

  def profile
    @user = current_user
    my_pets
    requests
    adoptions
  end

  # GET /users/1/edit
  def edit
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to my_profile_path, notice: 'El Usuario fue actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    respond_to do |format|
    if @user.destroy
      format.html { redirect_to all_users_url, notice: 'El usuario fue eliminado exitosamente.' }
      format.json { head :no_content }
    else
      format.html { redirect_to all_users_url }
      flash[:danger] = "Este usuario no se puede eliminar porque exiten mascotas y/o solicitudes de adopción relacionadas a él."
      end
    end
  end

  #CUSTOM

  def adopted_pets
    profile_or_show(params, current_user)
    my_pets
    respond_to do |format|
      format.js   { render :layout => false }
    end
  end

  def pets_for_adoption
    profile_or_show(params, current_user)
    adoptions
    respond_to do |format|
      format.js   { render :layout => false }
    end
  end

  def requests_for_pets
    profile_or_show(params, current_user)
    requests
    respond_to do |format|
      format.js   { render :layout => false }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if current_user.admin?
        params.require(:user).permit(:name, :lastName, :province, :city, :admin, :phone, :photo)
      else
        params.require(:user).permit(:name, :lastName, :province, :city, :phone, :photo)
      end        
    end

    def profile_or_show(params, current_user)
      !params['id'] ? @user = current_user : set_user
    end

    def my_pets
      @my_pets = @user.owned_pets
      @my_pets = @my_pets.paginate(page: params[:myPets_page], per_page: 9)
    end

    def adoptions
      @adoptions = @user.pets.where("pets.deleted = false")
      @adoptions = @adoptions.paginate(page: params[:adoptions_page], per_page: 6)
    end

    def requests
      @requests = @user.animals.joins(:adoptions).where("adoptions.status != 'accepted'").uniq
      @requests = @requests.paginate(page: params[:requests_page], per_page: 12)
    end
end
