class AdminController < ApplicationController
  layout 'application'
  before_action :authenticate_user!

  protected

  def authenticate_user!
    super
    return head :bad_request unless current_user.admin?
  end

end