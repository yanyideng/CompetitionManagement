class Achievement < ApplicationRecord
  belongs_to :group

  def self.filter(cons = {})
    _self = self # Achievement
    comps = Competition.all
    groups = Group.all
    # 根据条件查询
    # 比赛
    comps = comps.where(id: cons[:competition_id]) if cons[:competition_id]
    # 小组
    groups = groups.where(competition_id: comps.ids) unless comps.empty?
    _self = _self.where(group_id: groups.ids)
    _self = _self.where(prize: cons[:prize]) if cons[:prize]
    _self
  end
end
