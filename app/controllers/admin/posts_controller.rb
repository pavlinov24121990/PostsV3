# frozen_string_literal: true

module Admin
  class PostsController < AdminController
    before_action :post_find, only: %i[edit destroy update]

    include Pagy::Backend

    def index
      @post = current_user.posts.new
      @pagy, @posts = pagy(Post.order(created_at: :desc), items: 2)
    end

    def edit
      @pagy, @comments = pagy(@post.comments, items: 2)
    end

    def destroy
      if @post.destroy
        redirect_to admin_posts_path
        flash[:success] = 'Post deleted'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def update
      if @post.update(post_params)
        redirect_to edit_admin_post_path
        flash[:success] = 'Post updated'
      else
        @pagy, @comments = pagy(@post.comments, items: 2)
        render :edit, status: :unprocessable_entity
      end
    end

    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        respond_to do |format|
          format.turbo_stream do
            @pagy, @posts = pagy(Post.order(created_at: :desc), items: 2)
            render turbo_stream: turbo_stream.update(:post, partial: "posts", locals: { posts: @posts, pagy: @pagy })
          end
        end
        flash[:success] = 'Post created'
      else
        @pagy, @posts = pagy(Post.order(created_at: :desc), items: 2)
        render :index, status: :unprocessable_entity
      end
    end

    private

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def post_find
      @post = Post.find(params[:id])
    end
  end
end
