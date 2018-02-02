class AdoptionsController < ApplicationController
  before_action :set_adoption, only: [:show, :reject]
  before_action :require_user, only: [:new, :create, :edit, :update, :destroy, :reject]
  before_action :require_admin, only: [:index, :show]
  before_action only: [:edit, :update, :destroy, :reject] do
    require_owner_or_admin(params[:userId], params[:petId])
  end
  before_action only: [:new, :create] do
    not_pet_user(params[:petId])
  end

  # GET /adoptions
  # GET /adoptions.json
  def index

    if params["data"].present? && (params['data']['email'].present? || params['data']['name'].present? || params['data']['status'].present?)
      email = params['data']['email']
      name = params['data']['name']
      if params['data']['status'] == 'Creada'
        status = 'created'
      elsif params['data']['status'] == 'Rechazada'
        status = 'rejected'
      elsif params['data']['status'] == 'Aceptada'
        status = 'accepted'
      elsif params['data']['status'] == 'Retornada'
        status = 'returned'
      elsif params['data']['status'] == 'Cerrada'
        status = 'closed'
      elsif params['data']['status'] == 'Incompleta'
        status = 'incomplete'
      else
        status = ''
      end

      @adoptions = Adoption.paginate(page: params[:page], per_page: 5).all.joins(:user, :animal).where("users.email LIKE ? AND pets.name LIKE ? AND status LIKE ?", "%"+email+"%", "%"+name+"%", "%"+status+"%").order("created_at desc")
      @adoptions.count < 1 ? @search_results = 0 : @search_results = @adoptions.count
      
    else
      @adoptions = Adoption.paginate(page: params[:page], per_page: 5).all.order(created_at: :desc)
    end
  end

  # GET /adoptions/1
  # GET /adoptions/1.json
  def show
  end

  # GET /adoptions/new
  def new
    @adoption = Adoption.new
  end

  # GET /adoptions/1/edit
  def edit
    pet = Pet.find(params[:petId])
    user = Pet.owner_admin(pet, current_user)
    @adoption = Adoption.where(user: user, animal: params[:petId]).first
  end

  # POST /adoptions
  # POST /adoptions.json
  def create
    pet = Pet.find(params[:petId])
    if Adoption.adoption_not_incomplete_exists(current_user, pet)
      flash[:danger] = "Una solicitud de adopción con las mismas características ya fue solicitada."
      redirect_to adoptions_path
    else
      @adoption = Adoption.new(adoption_params)
      @adoption.user = current_user
      @adoption.animal = pet
      @adoption.status = "created"
      @adoption.received = false
      respond_to do |format|
        if @adoption.save
          MessageMailer.adoption_created(@adoption).deliver_now
          MessageMailer.adoption_created_owner(@adoption, pet).deliver_now
          format.html { redirect_to pet_path(pet), notice: 'La solicitud de adopción fue creada, pronto recibirá una respuesta. Gracias por su interés.' }
          format.json { render :show, status: :created, location: @adoption }
        else
          format.html { render :new }
          format.json { render json: @adoption.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  # PATCH/PUT /adoptions/1
  # PATCH/PUT /adoptions/1.json
  def update
    pet = Pet.find(params[:petId])
    @adoption = find_adoption(params[:userId], params[:petId])
    if params[:type] == 'accepted'
      owner = Pet.search_owner(pet) # Required to send emails
      adoptions_affected_by_change(params[:userId], params[:petId], 'incomplete')
      @adoption.status = "accepted"
      notice = 'La solicitud de adopción fue aceptada, confiamos en tu criterio.'
    elsif params[:type] == 'rejected'
      @adoption.status = "rejected"
      notice = 'La solicitud de adopción fue rechazada, confiamos en tu criterio.'
    elsif params[:type] == 'received'
      @adoption.received = true
      adoptions_affected_update(params[:userId], params[:petId], 'closed')
      notice = 'Has confirmado que la mascota esta ahora en tus manos.'
    elsif params[:type] == 'keep'
      adoptions_affected_by_change(params[:userId], params[:petId], 'incomplete')
      @adoption.status = "accepted"
      notice = 'Has confirmado que decidiste conservar la mascota.'
    end
    respond_to do |format|
      if @adoption.update(@adoption.attributes)
        if params[:type] == 'accepted'
          MessageMailer.adoption_accepted(@adoption, owner).deliver_now
          MessageMailer.adoption_accepted_owner(@adoption, owner).deliver_now
        elsif params[:type] == 'rejected'
          MessageMailer.adoption_rejected(@adoption).deliver_now
        elsif params[:type] == 'received'
          MessageMailer.adoption_received(@adoption).deliver_now
        elsif params[:type] == 'keep'
           MessageMailer.adoption_keep(@adoption).deliver_now
        end
        format.html { redirect_back fallback_location: root_path, notice: notice }
        format.json { render :show, status: :ok, location: @adoption }
      else
        format.html { render :edit }
        format.json { render json: @adoption.errors, status: :unprocessable_entity }
      end
    end
  end

  def reject
    @adoption.status = "returned"
    @adoption.rejectReason =   params[:adoption][:rejectReason]
    adoptions_affected_created(params[:userId], params[:petId], 'created')
    owner = Pet.search_owner(pet) # Required to send emails
    respond_to do |format|
      if @adoption.update(@adoption.attributes) && @adoption.valid?(:reject)
        MessageMailer.adoption_returned(@adoption).deliver_now
        if owner != @adoption.user # if the owner has received the pet he will be the actual owner
          MessageMailer.adoption_returned_owner(@adoption, owner).deliver_now
        end
        format.html { redirect_to my_profile_path, notice: 'Has rechazado conservar las mascota, esta volvera a estar disponible para ser adoptada.' }
        format.json { render :show, status: :ok, location: @adoption }
      else
        format.html { render :edit }
        format.json { render json: @adoption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adoptions/1
  # DELETE /adoptions/1.json
  def destroy
    @adoption = Adoption.where(user_id: params[:userId], pet_id: params[:petId]).first
    pet = Pet.find(params[:petId])
    if @adoption.status == "created"
      @adoption.destroy
      respond_to do |format|
        MessageMailer.adoption_deleted(@adoption).deliver_now
        MessageMailer.adoption_deleted_owner(@adoption, pet).deliver_now
        format.html { redirect_to my_profile_path, notice: 'La solicitud de adopción se eliminó exitosamente.' }
        format.json { head :no_content }
      end
    else
      redirect_back fallback_location: my_profile_path, notice: 'El estado de la adopción no permite eliminarla.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_adoption
      @adoption = Adoption.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def adoption_params
      params.require(:adoption).permit(:user_id, :pet_id, :status, :comments, :rejectReason)
    end

    def find_adoption(user, pet)
      Adoption.where(user_id: user, pet_id: pet).first
    end

    def adoptions_affected_by_change(user, pet, status)
      adoptions = Adoption.where(pet_id: pet).where.not(user_id: user)
      adoptions.each do |adoption|
        if adoption.status != 'returned' && adoption.status != 'closed' && adoption.status != 'rejected'
          adoption.status = status
          MessageMailer.adoption_rejected(@adoption).deliver_now
        end
        adoption.update(adoption.attributes)
      end
    end

    def adoptions_affected_created(user, pet, status)
      adoptions = Adoption.where(pet_id: pet).where.not(user_id: user)
      adoptions.each do |adoption|
        if adoption.status != 'returned' && adoption.status != 'closed' && adoption.status != 'rejected' && adoption.created_at > 2.months.ago
          adoption.status = status
          MessageMailer.adoption_reactivated(@adoption).deliver_now
        end
        adoption.update(adoption.attributes)
      end
    end

    def adoptions_affected_update(user, pet, status)
      adoptions = Adoption.where(pet_id: pet).where.not(user_id: user)
      adoptions.each do |adoption|
        if adoption.status == 'returned'
          adoption.status = status
        end
        adoption.update(adoption.attributes)
      end
    end
end
