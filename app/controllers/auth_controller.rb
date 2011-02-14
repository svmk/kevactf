class AuthController < ApplicationController
  # GET /auth
  def index
    @logged = session[:logged]
    logger.debug "Logged: #{@logged}"
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
    user = User.where(:nickname => login)
    @logged = session[:logged] or false
    @admin = session[:admin] or false
    if user and user.length > 0 then
      if user[0].nickname == password and user[0].enabled then
        @logged = true
        if user[0].admin then
          @admin = true
        end
        session[:user_id] = user[0].id
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
