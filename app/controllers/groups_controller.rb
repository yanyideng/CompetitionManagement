class GroupsController < ApplicationController
  def index
    @groups = Group.all.order(created_at: :desc)
  end

  def show
    @group = Group.find(params[:id])
    @teacher = nil
    teacher_rela = GuideTeacher.where(group_id: @group.id)
    if !teacher_rela.empty?
      @teacher = Teacher.find(teacher_rela[0].teacher_id)
    end
  end


  def edit
    @group = Group.find(params[:id])
    college = @group.student.college
    teachers = college.teachers
    @select_array = Array.new
    teachers.each do |teacher|
      @select_array << [teacher.name, teacher.id]
    end
  end

  def update
    GuideTeacher.create(group_id: params[:group_id], teacher_id: params[:teacher_id])
    redirect_to groups_path
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    redirect_to groups_path
  end

end
