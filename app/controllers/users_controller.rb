require 'digest/md5'
class UsersController < ApplicationController
  # GET /users
  def index
    if session[:admin] then
      @users = User.all

      respond_to do |format|
        format.html # index.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /users/1
  def show
    if not session[:logged] then
      redirect_to :controller=>'auth',:action=>'index'
      return
    end
    if User.exists?(params[:id]) then
      @user = User.find(params[:id])
      if @user.enabled or session[:admin] then
        respond_to do |format|
          format.html # show.html.erb
        end
      else
        render :template => "public/404",  :status => 404
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /users/new
  def new
    if session[:admin] then
      @user = User.new

      respond_to do |format|
        format.html # new.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /users/1/edit
  def edit
    if session[:admin] then
      @user = User.find(params[:id])
    else
      render :template => "public/404",  :status => 404
    end
  end

  # POST /users
  def create
    if session[:admin] then
      p = params[:user]
      if p[:price].type != Fixnum then
        p[:price] = 0
      end
      p[:md5hash] = ''
      p[:last_time] = DateTime.now
      @user = User.new(p)
      respond_to do |format|
        if @user.save then
          format.html { redirect_to :action=>'index', :notice => 'User was successfully created.' }
        else
          format.html { render :action => "new" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # PUT /users/1
  def update
    if session[:admin] and User.exists?(params[:id]) then
      @user = User.find(params[:id])

      respond_to do |format|
        if @user.update_attributes(params[:user])
          format.html { redirect_to(:action=>'index', :notice => 'User was successfully updated.') }
        else
          format.html { render :action => "edit" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # DELETE /users/1/delete
  def destroy
    if session[:admin] and User.exists?(params[:id]) then
      @user = User.find(params[:id])
      @user.destroy

      respond_to do |format|
        format.html { redirect_to(users_url) }
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /email_error
  def email_error
    respond_to do | format |
      format.html
    end
  end

  # GET /check_email
  def check_email
    respond_to do | format |
      format.html
    end
  end

  # GET /registration_complete
  def message_ok
    respond_to do | format |
      format.html
    end
  end

  # GET /user_not_exists
  def message_fail
    respond_to do | format |
      format.html
    end
  end

  # GET /activate
  def activate
    user = User.where(:md5hash => params[:key]).first
    if user and user.md5hash !='' then
      user.enabled = true
      user.save
      email = Registration.activated_mail(user,request.host)
      email.deliver
      redirect_to :action=>'message_ok'
    else
      redirect_to :action=>'message_fail'
    end
  end
  
  # GET /register
  def register
    register_end_str = KevaConfig.where(:key => 'register_end').first.value
    if DateTime.now < ((register_end_str!='') ?
          DateTime.parse(register_end_str) : DateTime.now) and 
        KevaConfig.where(:key=>'register_enabled').first.value == "Enabled" or
        session[:admin] then
      @user = User.new
      respond_to do |format|
        format.html # new.html.erb
      end
    else
      render :template => "users/reg_end"
    end    
  end

  # GET /do_register
  def do_register
    register_end_str = KevaConfig.where(:key => 'register_end').first.value
    if DateTime.now < ((register_end_str!='') ?
          DateTime.parse(register_end_str) : DateTime.now) and
        KevaConfig.where(:key=>'register_enabled').first.value == "Enabled" or
        session[:admin] then
      chars = ['0'..'9','a'..'z','A'..'Z'].map{ |r| r.to_a }.flatten
      password =  Array.new(20){ chars[ rand( chars.size ) ] }.join
      @user = User.new(:realname => params[:realname],
        :nickname => params[:nickname],
        :university => params[:university],
        :email => params[:email],
        :password=>password,
        :enabled => false,
        :admin => false,
        :price => 0,
        :md5hash => Digest::MD5.hexdigest(rand(10000000000000000000000).to_s),
        :last_time => DateTime.now)

      respond_to do |format|
        if @user then
          email = Registration.registration_mail(@user,request.host)
          if email and not email.deliver.errors.any? then
            if @user.save then
              format.html { redirect_to :action=>'check_email'}
            else
              format.html { render :action => "register" }
            end
          else
            format.html { redirect_to :action=>'email_error'}
          end
          
        end
      end
    else
      render :template => "users/reg_end"
    end
  end
  
end
