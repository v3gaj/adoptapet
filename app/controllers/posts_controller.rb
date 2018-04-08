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
    @posts = @pet.posts.all.order(created_at: :desc).limit(Post::POSTSPERREFRESH)
    respond_to do |format|
      if @post.save
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
        index = show_posts_after_update(posts.index(@post))
        # Determine the number of posts shown for show more posts link
        @count = (index / Post::POSTSPERREFRESH) - 1
        @posts = posts.take(index)
        @postsCount = posts.count
            puts @postsCount 
    puts @posts.count
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
    @post.destroy
    respond_to do |format|
      format.html { redirect_to @pet, notice: 'La publicación se ha eliminado exitosamente.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  def addFive
    # Determine the number of posts shown for show more posts link
    count = params['count'].to_i + 1
    @count = count
    index = count * Post::POSTSPERREFRESH
    posts = @pet.posts.all.order(created_at: :desc)
    @posts = posts[index, Post::POSTSPERREFRESH]
    @postsCount = posts.count
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

    def show_posts_after_update(postIndex)
      b = postIndex / Post::POSTSPERREFRESH
      index = b * Post::POSTSPERREFRESH + Post::POSTSPERREFRESH
    end
end
