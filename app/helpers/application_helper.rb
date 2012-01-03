module ApplicationHelper

  def profile_link(attributes = {})
    link_to "Profile", {:controller => :users, :action => :profile, :id => @logged_user.to_param}, attributes
  end

  def reverse_elements(array)
    array.collect{|a| a.reverse}
  end

  def select_model(collection)
    collection.collect{|e| [e.id, e.name]}
  end

  def admin_area
    if @logged_user and @logged_user.access_level == 3
      yield
    end
  end

end
