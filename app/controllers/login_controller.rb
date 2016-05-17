class LoginController < ApplicationController
  skip_before_action :check_authorization, only: [:index, :authenticate, :logout]
  #layout "application"

  def index
    render :layout => false
  end

  def authenticate
    if @logged_in = Employee.authenticate(params[:admin_employee])
      session[:login] = params[:admin_employee]
      session[:last_access] = Time.now
      redirect_to hours_worked_path Time.now.strftime("%Y%m%d")
    else
      flash[:notice] = 'Invalid username or password'
      render :action => 'index', :layout => false
    end
  end

  def logout
    session[:login] = nil
    session[:last_access] = nil
    redirect_to login_path
  end
end
