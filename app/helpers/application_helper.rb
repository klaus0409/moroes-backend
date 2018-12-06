module ApplicationHelper
  def active_item(controller, *actions)
    return if controller_name != controller

    if actions.present?
      'active' if action_name.in?(actions)
    else
      'active'
    end
  end
end
