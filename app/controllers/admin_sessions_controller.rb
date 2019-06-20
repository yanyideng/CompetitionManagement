class AdminSessionsController < ApplicationController
  include AdminSessionsHelper
  def new
  end

  def create
    name = params[:admin_session][:name]
    password = params[:admin_session][:password]
    admin = Admin.find_by_name(name)
    if admin && admin.authenticate(password)
      log_in(admin)
      redirect_to colleges_path
    else
      flash[:notice] = "Invalid login or password."
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
