class AuthController < ApplicationController
  # GET /auth
  def index
    @logged = session[:logged]
    if not @logged then
    respond_to do |format|
      format.html # index.html.erb
    end
    else
      redirect_to :action => "index", :controller => 'main_page'
    end
  end

  # POST /auth/login
  def login
    login = params[:login]
    password = params[:password]
    user = User.where(:nickname => login).first
    @logged = session[:logged] or false
    @admin = session[:admin] or false
    if user then
      if user.password == password and user.enabled then
        @logged = true
        if user.admin then
          @admin = true
        end
        session[:user_id] = user.id
        session[:logged]  = @logged
        session[:admin ]  = @admin
      end
    end      
    if not @logged then
      respond_to do |format|
        format.html # index.html.erb
      end
    else 
      redirect_to :action => "index", :controller => 'main_page'
    end
  end

  # GET /auth/logout
  def logout
    session[:user_id] = 0
    session[:logged] = false
    session[:admin]  = false
    logger.debug "Reffer: #{params[:reffer]}"
    logger.debug "Session is ended."
    redirect_to root_url
  end
end
