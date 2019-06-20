module ClientSessionsHelper
  def log_in(student)
    session[:student_id] = student.id
  end

  def current_user
    if session[:student_id] != nil
      @current_student = Student.find_by_id(session[:student_id])
    else
      @current_student = nil
    end
    @current_student
  end

  #用来判断用户是否登录的方法
  def logged_in?
    !current_user.nil?
  end
end
