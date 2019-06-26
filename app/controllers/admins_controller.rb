class AdminsController < ApplicationController
  def new
    @admin = Admin.new
  end

  def create
    #render plain: params.inspect
    @admin = Admin.new
    @admin.name = params[:name]
    @admin.password = params[:password]
    if params[:code] == '1dao8' && @admin.save
        redirect_to root_path
    else
      if params[:code] != '1dao8'
        flash[:notice] = '邀请码错误'
      end
      render 'new'
    end
  end
end
