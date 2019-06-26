class ClientSessionsController < ApplicationController
  include ClientSessionsHelper
  before_action :check_stu_or_admin_login, only: [:new, :create]
  def new
  end

  def create
    student_id = params[:client_session][:student_id]
    password = params[:client_session][:password]
    student = Student.find_by_student_id(student_id)
    if student && student.authenticate(password)
      log_in(student)
      redirect_to client_profile_path
    else
      flash[:notice] = "错误的学号或密码"
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
