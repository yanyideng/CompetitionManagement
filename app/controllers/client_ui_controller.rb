class ClientUiController < ApplicationController
  def profile
    @student = Student.find_by_id(session[:student_id])
  end

  def competition
    @competitions = Competition.all
  end

  def group
    @groups = Group.find_by_student_id(session[:student_id])
  end
end
