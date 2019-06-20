class AchievementController < ApplicationController
  def index
    @achievements = Achievement.all
  end

  def show
    @achievement = Achievement.find(params[:id])
    @group = Group.find(@achievement.group_id)
    @competition = Competition.find(@group.competition_id)
  end

  def destroy
    @achievement = Achievement.find(params[:id])
    @achievement.destroy
  end

end
