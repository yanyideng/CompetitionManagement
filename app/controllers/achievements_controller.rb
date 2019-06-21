class AchievementsController < ApplicationController
  def index
    @achievements = Achievement.all
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
