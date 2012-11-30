module School::SettingsHelper

  def teacher_icons teacher, badges = []
    unless badges.is_a? Array
      badges = badges.split(',')
    end
    icons = [['badge-' + teacher.type.downcase,teacher.name + " is a " + teacher.type.titleize]]
    if badges.include?('badge-reward-distributor') || teacher.can_distribute_rewards?(current_school)
      icons << ['badge-reward-distributor',teacher.name + ' can distribute rewards']
    end
    icons
  end


end
