module Admin
  class PostsController < ApplicationController
    before_action :user_params, only: %i[new create]
    before_action :admin_acces
    before_action :post_find, only: %i[show edit destroy update]

    def index
      @post = Post.order(created_at: :desc)
    end

    def new
      @post = @user.posts.new
    end
    
    def show
    end

    def edit
    end

    def destroy
      if @post.destroy
        redirect_to admin_posts_path
        flash[:success] = "Post deleted"
      else
        render :show
      end
    end

    def update
      if @post.update(post_params)
        redirect_to admin_post_path
        flash[:success] = "Post updated"
      else
        render :edit
      end
    end

    def create
      @post = @user.posts.build(post_params)
      if @post.save
        redirect_to admin_posts_path
        flash[:success] = "Post created"
      else
        render :new
      end
    end

    private
    def post_params
      params.require(:post).permit(:title, :body)
    end
    
    def user_params
      @user = current_user
    end

    def post_find
      @post = Post.find(params[:id])
    end

    def admin_acces
      unless current_user&.status?
        flash[:alert] = 'Доступ запрещен'
        redirect_to root_path
      end
    end
  end
end
