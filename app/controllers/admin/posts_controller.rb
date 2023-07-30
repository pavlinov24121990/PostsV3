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
      @UpdateCreateButton = " "
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
        respond_to do |format|
          format.turbo_stream do
            flash[:success] = 'Post Updated'
            render turbo_stream: [turbo_stream.update(:post, partial: "postEdit", locals: { post: @post}), 
                                 turbo_stream.update(:form, partial: "shared/form", locals: { post: @post}), 
                                 turbo_stream.update(:flash, partial: "shared/flash")]
          end
        end
      else
        render turbo_stream: turbo_stream.update(:errors, partial: "shared/errors", status: :unprocessable_entity, locals: { object: @post})
      end
    end

    def create
      @post = current_user.posts.build(post_params)
      if @post.save
        respond_to do |format|
          format.turbo_stream do
            @pagy, @posts = pagy(Post.order(created_at: :desc), items: 2)
            flash[:success] = 'Post created'
            render turbo_stream: [turbo_stream.update(:post, partial: "posts", locals: { posts: @posts, pagy: @pagy }), 
                                 turbo_stream.update(:form, partial: "shared/form", locals: { post: Post.new }), 
                                 turbo_stream.update(:flash, partial: "shared/flash")]
          end
        end
      else
        render turbo_stream: turbo_stream.update(:errors, partial: "shared/errors", status: :unprocessable_entity, locals: { object: @post})
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
