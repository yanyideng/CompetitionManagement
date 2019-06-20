class ClientUiController < ApplicationController
  def profile
    @student = Student.find_by_id(session[:student_id])
  end

  def competition
    @competitions = Competition.all.order(deadline: :desc)
    @current_date = Time.now.to_date
  end

  def group
    @groups = Group.where(student_id: session[:student_id]).order(created_at: :desc)
  end

  def group_detail
    @group = Group.find_by_id(params[:id])
  end

  def create_group
    temp_competition_id = params[:id]
    temp_student_id = session[:student_id]
    @group = Group.create(competition_id: temp_competition_id, student_id: temp_student_id)
    redirect_to client_group_path
  end
end
