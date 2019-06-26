module ApplicationHelper
  def student_logged_in?
    !session[:student_id].nil?
  end

  def admin_logged_in?
    !session[:admin_id].nil?
  end

  def check_stu_login
    redirect_to client_login_url unless student_logged_in?
  end

  def check_admin_login
    redirect_to admin_login_url unless admin_logged_in?
  end

  def check_stu_or_admin_login
    redirect_to colleges_url and return if admin_logged_in?
    redirect_to client_profile_url and return if student_logged_in?
  end
end
