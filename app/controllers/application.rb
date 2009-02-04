# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  before_filter :prepeare_menu, :prepeare_users

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'cac253ff836bba66e0bb65219314fba1'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

#  private

  def prepeare_menu
    @count_of_new_ent = Entity.find(:all, :conditions => "is_submit is NULL").size
    @count_of_users = User.find(:all).size
    @count_of_ent = Entity.find(:all, :conditions => "is_submit = 1 AND is_transfer = 1").size
  end

  def prepeare_users
    if session[:user] && User.find_by_id(session[:user].id)
      @is_user = true
    end
    if session[:user] && User.find_by_id(session[:user].id) && (session[:user].perms == 'moder' || session[:user].perms == 'admin')
      @is_moder = true
    end
    if session[:user] && User.find_by_id(session[:user].id) && session[:user].perms == 'admin'
      @is_admin = true
    end
  end

  def kick_not_user
    unless session[:user] && User.find_by_id(session[:user].id)
      session[:original_uri] = request.request_uri
      flash[:notice] = "Вам нужно сначала зайти на в систему"
      redirect_to(:controller => "entities", :action => "index")
    end
  end

  def kick_not_moder
    unless (session[:user] && User.find_by_id(session[:user].id) && (session[:user].perms == 'moder' || session[:user].perms == 'admin'))
      flash[:notice] = "Доступ к этому разделу запрещен"
      redirect_to(:controller => "entities", :action => "index")
    end
  end

  def kick_not_admin
    unless (session[:user] && User.find_by_id(session[:user].id) && session[:user].perms == 'admin')
      flash[:notice] = "Доступ к этому разделу запрещен"
      redirect_to(:controller => "entities", :action => "index")
    end
  end
  
  def kick_not_owner
    unless (session[:user].id == params[:id].to_i)
      flash[:notice] =  "Доступ к этому разделу запрещен"
      redirect_to(:controller => "entities", :action => "index")
    end
  end
  
  def is_user(id)
    if id != session[:user].id
      return true
    else
      return false 
    end
  end

end