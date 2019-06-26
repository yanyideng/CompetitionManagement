class AchievementsController < ApplicationController
  before_action :check_admin_login
  def index
    competitions = Competition.all
    @select_array = Array.new
    @select_array << ['全部', '']
    competitions.each do |competition|
      competition_full_name = '第' + competition.version.to_s + '届' + competition.name
      @select_array << [competition_full_name, competition.id]
    end
    conditions = params.slice(:competition_id, :prize)
    conditions.each { |k, v| conditions.delete(k) if v.empty? }
    @achievements = Achievement.filter(conditions)
  end

  def show
    @achievement = Achievement.find(params[:id])
    @competition = @achievement.group.competition
  end

  def destroy
    @achievement = Achievement.find(params[:id])
    @achievement.destroy
  end

end
