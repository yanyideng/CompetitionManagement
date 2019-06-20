class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    #@guide_teacher = @group.guide_teacher
    #@guide_teacher_name = Teacher.find(@guide_teacher.teacher_id)
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:name])

    if @guide_teacher && Guide_teacher.update(teacher_id: @teacher.teacher_id) && Guide_teacher.update(group_id: params[:group_id])
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to groups_path
  end

end
