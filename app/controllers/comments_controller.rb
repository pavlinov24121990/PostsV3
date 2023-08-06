# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]
  before_action :post_find
  before_action :comment_find, except: %i[create]

  include Pagy::Backend

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      respond_to do |format|
        format.turbo_stream do
          redirect_to post_path(@post)
          flash[:success_create_comment] = 'Comment go approved to admin!'
        end
      end
    else
      render turbo_stream: turbo_stream.update(:errors, partial: "shared/errors", status: :unprocessable_entity, locals: { object: @comment})
    end
  end

  def edit
    @ButtonCreateUpdate = " "
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.destroy
      respond_to do |format|
        format.turbo_stream do
          flash[:success] = 'Comment Deleted!'
          @pagy, @comments = pagy(@post.comments, items: 2)
          render turbo_stream: turbo_stream.update(:comments_paginate, partial: "admin/posts/comments", locals: { comments: @comments, pagy: @pagy })
        end
      end
    else
      redirect_to edit_admin_post_path(@post)
      flash[:success] = 'Error'
    end
  end

  def update
    @comment = @post.comments.find(params[:id])
    if @comment.update(comment_params)
      respond_to do |format|
        format.turbo_stream do
          redirect_to edit_admin_post_path(@post)
          flash[:success] = 'Comment update!'
        end
      end
    else
      render turbo_stream: turbo_stream.update(:errors, partial: "shared/errors", status: :unprocessable_entity, locals: { object: @comment})
    end
  end

  protected

  def authenticate_user!
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(:modal, partial: "devise/sessions/new", locals: { show_modal: true})
        end
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def post_find
    @post = Post.find(params[:post_id])
  end

  def comment_find
    @comment = @post.comments.find(params[:id])
  end
end
