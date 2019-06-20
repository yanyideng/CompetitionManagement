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
      flash[:notice] = "错误的管理员用户名或密码"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
