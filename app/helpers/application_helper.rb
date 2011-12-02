module ApplicationHelper

  def profile_link(attributes = {})
    link_to "Profile", {:controller => :users, :action => :profile, :id => @logged_user.to_param}, attributes
  end

end
