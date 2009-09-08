class ContactsController < ApplicationController

  helper :custom_fields
  include CustomFieldsHelper   

  helper :sort
  include SortHelper
  
  skip_before_filter :check_if_login_required, :only => [:login, :lost_password, :register, :activate]

  def show
      sort_init 'login', 'asc'
      sort_update %w(login firstname lastname mail admin created_on last_login_on)

      @status = params[:status] ? params[:status].to_i : 1
      c = ARCondition.new(@status == 0 ? "status <> 0" : ["status = ?", @status])

      unless params[:name].blank?
          name = "%#{params[:name].strip.downcase}%"
          c << ["LOWER(login) LIKE ? OR LOWER(firstname) LIKE ? OR LOWER(lastname) LIKE ?", name, name, name]
      end

      @user_count = User.count(:conditions => c.conditions)
      @user_pages = Paginator.new self, @user_count,
          per_page_option,
          params['page']								

      @users =  User.find :all,:order => sort_clause,
          :conditions => c.conditions,
          :limit  =>  @user_pages.items_per_page,
          :offset =>  @user_pages.current.offset

      @headers = User.current.custom_values.map { |f| f.custom_field.name } 

      render :action => "show", :layout => false if request.xhr?	
  end
  
private
  def logged_user=(user)
    if user && user.is_a?(User)
      User.current = user
      session[:user_id] = user.id
    else
      User.current = User.anonymous
      session[:user_id] = nil
    end
  end
end
