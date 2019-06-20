class ClientUiController < ApplicationController
  def profile
    @student = Student.find_by_id(session[:student_id])
  end

  def competition
    @competitions = Competition.all
    @current_date = Time.now.to_date
  end

  def group
    @groups = Group.find_by_student_id(session[:student_id])
  end

  def create_group
  end
end
