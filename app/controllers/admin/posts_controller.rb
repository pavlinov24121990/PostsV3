module Admin
  class PostsController < ApplicationController
    before_action :admin_acces
    before_action :post_find, only: %i[edit destroy update]

    def index
      @posts = Post.order(created_at: :desc)
    end

    def new
      @post = current_user.posts.new
    end
    
    def edit
    end

    def destroy
      if @post.destroy
        redirect_to admin_posts_path
        flash[:success] = "Post deleted"
      else
        render :edit
      end
    end

    def update
      if @post.update(post_params)
        redirect_to admin_posts_path
        flash[:success] = "Post updated"
      else
        render :edit
      end
    end

    def create
      @post = current_user.posts.build(post_params)
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
    
    def post_find
      @post = Post.find(params[:id])
    end

    def admin_acces
      if current_user&.admin?
        flash[:success] = 'Доступ разрешён'
      else
        flash[:alert] = 'Доступ запрещен'
        redirect_to root_path
      end
    end
  end
end
