module AdminSessionsHelper
  def log_in(admin)
    session[:admin_id] = admin.id
  end

  def current_user
    if session[:admin_id] != nil
      @current_admin = Admin.find_by_id(session[:admin_id])
    else
      @current_admin = nil
    end
    @current_admin
  end

  #用来判断用户是否登录的方法
  def logged_in?
    !current_user.nil?
  end

  def log_out
    session[:admin_id] = nil
    @current_user = nil
  end
end
