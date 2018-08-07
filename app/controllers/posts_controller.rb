class PostsController < ApplicationController
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :set_pet, only: [:edit, :new, :create, :update, :destroy, :addFive]
  before_action :require_user, only: [:edit, :new, :create, :update, :destroy]
  before_action :pet_owner_editor, only: [:edit, :new, :create, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit

  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.pet_id = @pet.id
    session[:count] += 1
    @posts = @pet.posts.all.order(created_at: :desc).limit(session[:count])
    respond_to do |format|
      if @post.save
        create_photo(@pet.id, @post.image)
        @post = Post.new
        format.html { redirect_to pet_path(@pet), notice: 'La publicación se ha creado exitosamente.' }
        format.json { render :show, status: :created, location: @post }
        format.js   { render :layout => false }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js   { render :layout => false }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        posts = @pet.posts.all.order(created_at: :desc)
        @posts = posts.take(session[:count])
        session[:count] = @posts.count
        @post = Post.new
        format.html { redirect_to pet_path(@pet), notice: 'La publicación se ha actualizado exitosamente.' }
        format.json { render :show, status: :ok, location: @post }
        format.js   { render :layout => false }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
        format.js   { render :layout => false }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    session[:count] -= 1
    @post.destroy
    respond_to do |format|
      format.html { redirect_to @pet, notice: 'La publicación se ha eliminado exitosamente.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  def addFive
    posts = @pet.posts.all.order(created_at: :desc)
    @posts = posts[session[:count], Post::POSTSPERREFRESH]
    session[:count] += @posts.count
    @count = posts.count
    respond_to do |format|
      format.html { }
      format.json { render :show, status: :created, location: @post }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pet
      @pet = Pet.where(slug: params[:pet_id]).first
    end

    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:comment, :image)
    end

    def create_photo(pet_id, photo)
      if Photo.create(:pet_id => pet_id, :photo => photo).valid?
        puts 'Success'
      end
    end

end
