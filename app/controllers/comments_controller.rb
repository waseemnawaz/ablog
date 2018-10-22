class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  # GET /posts/:post_id/comments
  # GET /posts/:post_id/comments.json

  def index
    #@comments = Comment.all
    #1st you retrieve the post thanks to params[:post_id]
    #2nd you get all the comments of this post
    if params[:category].blank?
      post = Post.find(params[:post_id])
      @comments = post.comments
    else
      @category = Category.find_by_name(params[:category])
      post = Post.find(params[:post_id])
      @comments = post.comments.where(category: @category)
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  # GET /posts/:post_id/comments/:id
  # GET /posts/:post_id/comments/:id.json
  def show
    #1st you retrieve the post thanks to params[:post_id]
    #2nd you retrieve the comment thanks to params[:id]
    post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
  end

  # GET /comments/new
  # GET /posts/:post_id/comments/new
  def new
    #1st you retrieve the post thanks to params[:post_id]
    #2nd you build a new one
    #@comment = Comment.new
    post = Post.find(params[:post_id])
    @comment = post.comments.build
  end

  # GET /comments/1/edit
  # GET /posts/:post_id/comments/:id/edit
  def edit
    post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
  end

  # POST /comments
  # POST /comments.json
  # POST /posts/:post_id/comments
  # POST /posts/:post_id/comments.json
  def create
    #1st you retrieve the post thanks to params[:post_id]
    #2nd you create the comment with arguments in params[:comment]
    #@comment = Comment.new(comment_params)

    post = Post.find(params[:post_id])
    @comment = post.comments.create(comment_params)

    respond_to do |format|
      if @comment.save
        #format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.html { redirect_to([@comment.post, @comment], notice: 'Comment was successfully created.' )}
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  # PUT /posts/:post_id/comments/:id
  # PUT /posts/:post_id/comments/:id.json
  def update
    #1st you retrieve the post thanks to params[:post_id]
    #2nd you retrieve the comment thanks to params[:id]
    post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to([@comment.post, @comment], notice: 'Comment was successfully updated.' )}
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  # DELETE /posts/:post_id/comments/1
  # DELETE /posts/:post_id/comments/1.json

  def destroy
    #1st you retrieve the post thanks to params[:post_id]
    #2nd you retrieve the comment thanks to params[:id]
    post = Post.find(params[:post_id])
    @comment = post.comments.find(params[:id])
    @comment.destroy
    respond_to do |format|
      #1st argument reference the path /posts/:post_id/comments/
      #format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.html { redirect_to post_comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:commenter, :body, :post_id, :category_id)
    end
end
