class WelcomeController < ApplicationController
  before_action :check_stu_or_admin_login
  def index
  end
end
