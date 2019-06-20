class StudentsController < ApplicationController
  def index
    @students = Student.all
  end

  def show
    @student = Student.find(params[:id])
  end

  def new
    @student = Student.new
    @colleges = College.all
  end

  def edit
    @student = Student.find(params[:id])
    @colleges = College.all
  end

  def create
    @college = College.find_by_id(params[:student][:college_id])
    @student = @college.students.new(student_params)
    @colleges = College.all
    if @student.save
      redirect_to @student
    else
      render 'new'
    end
  end

  def update
    @student = Student.find(params[:id])
    @colleges = College.all

    if @student.update(student_params) && @student.update(college_id: params[:student][:college_id])
      redirect_to @student
    else
      render 'edit'
    end
  end

  def destroy
    @student = Student.find(params[:id])
    @student.destroy

    redirect_to students_path
  end

  private
  def student_params
    params.require(:student).permit(:student_id, :name, :email, :password)
  end
end
