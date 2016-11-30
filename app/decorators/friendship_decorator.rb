class FriendshipDecorator < Draper::Decorator
  delegate_all


  def user_view
    if h.current_user == object.user
      return object.friend
    end
    return object.user
  end

  def status_or_button
  	return buttons if object.pending? && object.user != h.current_user
  	return status
    
  end

  def status
  	return "Accepted" if object.active?
  	return "Denied" if object.denied?
  	return "Waiting answer" if object.pending?
  end
  def buttons
  	(confirm_button + denegate_button).html_safe
  end

  def confirm_button
  	h.link_to "Accept",h.friendship_path(object,status: 1),method: :patch,class: "padding-right mdl-button mdl-js-button mdl-button--raised mdl-button--colored"
  end

  def denegate_button
  	h.link_to "Denied", h.friendship_path(object,status: 0), method: :patch,class: "padding-right mdl-button mdl-js-button mdl-button--raised mdl-button--accent"
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
