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

  def edit_group
    @group = Group.find_by_id(params[:id])
  end

  def add_achievement
    @group = Group.find_by_id(params[:id])
  end

  def create_group
    temp_competition_id = params[:id]
    temp_student_id = session[:student_id]
    @group = Group.where("competition_id = ? AND student_id = ?", temp_competition_id, temp_student_id)
    if @group.empty?
      @group = Group.create(competition_id: temp_competition_id, student_id: temp_student_id)
      flash[:notice] = '请继续完善队伍信息！'
      redirect_to client_group_path
    else
      flash[:notice] = '请勿重复报名！'
      redirect_to client_competition_path
    end
  end

  def update_group
    #render plain:params[:group].inspect
    @group = Group.find_by_id(params[:group][:id])
    @group.name = params[:group][:name]
    @group.mema = params[:group][:mema]
    @group.memb = params[:group][:memb]
    @group.memc = params[:group][:memc]
    @group.memd = params[:group][:memd]
    @group.save
    flash[:notice] = '修改队伍信息完成'
    redirect_to client_group_url
  end

  def group_add_achievement
    achi = Achievement.find_by_group_id(params[:id])
    if achi.nil?
      Achievement.create(prize: params[:prize], group_id: params[:id])
    else
      achi.prize = params[:prize]
      achi.save
    end
    flash[:notice] = '修改获奖信息完成'
    redirect_to client_group_url
  end

  def edit_email
    @student = Student.find(session[:student_id])
  end

  def change_email
    email = params[:student][:email]
    if email.empty?
      flash[:notice] = '邮箱不能为空'
      redirect_to edit_email_url and return
    end
    student = Student.find(session[:student_id])
    student.email = email
    student.save(validate: false)
    flash[:notice] = '邮箱修改完成'
    redirect_to client_profile_url
  end

  def edit_password
    @student = Student.find(session[:student_id])
  end

  def change_password
    old_pass = params[:old_pass]
    new_pass = params[:new_pass]
    if (old_pass.size < 5) || (new_pass.size < 5)
      flash[:notice] = '密码必须大于5位'
      redirect_to edit_password_url and return
    end
    student = Student.find(session[:student_id])
    if student.authenticate(old_pass)
      student.password = new_pass
      student.save
      flash[:notice] = '密码修改成功'
      redirect_to client_profile_url
    else
      flash[:notice] = '旧密码错误'
      redirect_to edit_password_url
    end
  end
end
