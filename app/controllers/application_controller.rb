class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :check_authentication
  before_action :check_authorization

  def check_authentication
    if session[:login]
      @logged_in = Employee.where(username: session[:login][:username]).first
      if Time.now - session[:last_access] > @logged_in.timeout
        @logged_in = nil
      else
        session[:last_access] = Time.now
      end
    end
    rescue
      @logged_in = nil
  end

  def check_authorization
    redirect_to login_path unless @logged_in
    unless @logged_in and request.fullpath =~ /hours_worked|change_password/
      redirect_to login_path unless @logged_in.admin
    end
    rescue
      # do nothing.  will redirect to login_path
  end
end
