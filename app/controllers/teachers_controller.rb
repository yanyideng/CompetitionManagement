class TeachersController < ApplicationController
  before_action :check_admin_login
  def index
    @teachers = Teacher.all
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def new
    @teacher = Teacher.new
    @colleges = College.all
  end

  def edit
    @teacher = Teacher.find(params[:id])
    @colleges = College.all
  end

  def create
    @college = College.find_by_id(params[:teacher][:college_id])
    @teacher = @college.teachers.new(teacher_params)
    @colleges = College.all
    if @teacher.save
      redirect_to @teacher
    else
      render 'new'
    end
  end

  def update
    @teacher = Teacher.find(params[:id])
    @colleges = College.all
    if @teacher.update(teacher_params) && @teacher.update(college_id: params[:teacher][:college_id])
      redirect_to @teacher
    else
      render 'edit'
    end
  end

  def destroy
    @teacher = Teacher.find(params[:id])
    @teacher.destroy
    redirect_to teachers_path
  end

  private
  def teacher_params
    params.require(:teacher).permit(:teacher_id, :name)
  end
end
