class AdminController < ApplicationController
  # GET /admin
  def index
    logger.debug "Admin page: #{session[:admin].inspect}"
    if session[:admin] then
      @email_errors = []
      irc_item = KevaConfig.where(:key => 'irc').first
      email_item = KevaConfig.where(:key => 'email').first
      news_comments_item = KevaConfig.where(:key => 'news_comments').first
      register_end_item = KevaConfig.where(:key => 'register_end').first
      register_enabled_item = KevaConfig.where(:key => 'register_enabled').first
      game_begin_item = KevaConfig.where(:key => 'game_begin').first
      game_end_item = KevaConfig.where(:key => 'game_end').first
      game_enabled_item = KevaConfig.where(:key => 'game_enabled').first
      main_page_content_item = KevaConfig.where(:key => 'main_page_content').first
      user_delay_item = KevaConfig.where(:key => 'user_delay').first
      countdown_item = KevaConfig.where(:key => 'countdown').first
      
      @irc = irc_item ? irc_item.value : ""
      @email = email_item ? email_item.value : ""
      @news_comments = news_comments_item ? news_comments_item.value : "Disabled"
      @register_end = register_end_item ? (register_end_item.value != "" ? DateTime.parse(register_end_item.value) : DateTime.now.utc) : DateTime.now.utc
      @register_enabled = register_enabled_item ? register_enabled_item.value : "Disabled"
      @game_begin = game_begin_item ? (game_begin_item.value != "" ? DateTime.parse(game_begin_item.value): DateTime.now.utc) : DateTime.now.utc
      @game_end = game_end_item ? (game_end_item.value != "" ? DateTime.parse(game_end_item.value): DateTime.now.utc) : DateTime.now.utc
      @game_enabled = game_enabled_item ? game_enabled_item.value : "Disabled"
      @main_page_content = main_page_content_item ? main_page_content_item.value : ""
      @user_delay = user_delay_item ? DateTime.parse(user_delay_item.value) : nil
      @countdown = countdown_item ? countdown_item.value : "Disabled"
      respond_to do |format|
        format.html # new.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end
  # POST /admin
  def update
    if session[:admin] then
      irc_item = KevaConfig.where(:key => 'irc').first
      if not irc_item then
        irc_item = KevaConfig.create(:key=>'irc',:value=>params[:irc])
      end
      irc_item.value = params[:irc]
      irc_item.save

      email_item = KevaConfig.where(:key => 'email').first
      if not email_item then
        email_item = KevaConfig.create(:key=>'email',:value=>params[:email])
      end
      email_item.value = params[:email]
      email_item.save

      news_comments_item = KevaConfig.where(:key => 'news_comments').first
      if not news_comments_item then
        news_comments_item = KevaConfig.create(:key=>'news_comments',:value=>params[:news_comments])
      end
      news_comments_item.value = params[:news_comments]
      news_comments_item.save
      
      register_end_item = KevaConfig.where(:key => 'register_end').first
      if not register_end_item then
        register_end_item = KevaConfig.create(:key=>'register_end',:value=>'')
      end
      register_end_item.value = DateTime.civil( params[:register_end][:year].to_i,
        params[:register_end][:month].to_i,params[:register_end][:day].to_i,
        params[:register_end][:hour].to_i,params[:register_end][:minute].to_i).
        strftime('%a, %d %b %Y %H:%M:%S UTC')
      register_end_item.save
      register_enabled_item = KevaConfig.where(:key => 'register_enabled').first
      if not register_enabled_item then
        register_enabled_item = KevaConfig.create(:key=>'register_enabled',:value=>params[:register_enabled])
      end
      register_enabled_item.value = params[:register_enabled]
      register_enabled_item.save

      game_begin_item = KevaConfig.where(:key => 'game_begin').first
      if not game_begin_item then
        game_begin_item = KevaConfig.create(:key=>'game_begin',:value=>'')
      end
      game_begin_item.value = DateTime.civil( params[:game_begin][:year].to_i,
        params[:game_begin][:month].to_i,params[:game_begin][:day].to_i,
        params[:game_begin][:hour].to_i,params[:game_begin][:minute].to_i).
        strftime('%a, %d %b %Y %H:%M:%S UTC')
      game_begin_item.save

      game_end_item = KevaConfig.where(:key => 'game_end').first
      if not game_end_item then
        game_end_item = KevaConfig.create(:key=>'game_end',:value=>'')
      end
      game_end_item.value = DateTime.civil( params[:game_end][:year].to_i,
        params[:game_end][:month].to_i,params[:game_end][:day].to_i,
        params[:game_end][:hour].to_i,params[:game_end][:minute].to_i).
        strftime('%a, %d %b %Y %H:%M:%S UTC')
      game_end_item.save
      
      game_enabled_item = KevaConfig.where(:key => 'game_enabled').first
      if not game_enabled_item then
        game_enabled_item = KevaConfig.create(:key=>'game_enabled',:value=>params[:game_enabled])
      end
      game_enabled_item.value = params[:game_enabled]
      game_enabled_item.save
      
      main_page_content_item = KevaConfig.where(:key => 'main_page_content').first
      if not main_page_content_item then
        main_page_content_item = KevaConfig.create(:key=>'main_page_content',:value=>params[:main_page_content])
      end
      main_page_content_item.value = params[:main_page_content]
      main_page_content_item.save

      user_delay_item = KevaConfig.where(:key => 'user_delay').first
      if not user_delay_item then
        user_delay_item = KevaConfig.create(:key=>'user_delay',:value=>'')
      end
      user_delay_item.value = DateTime.civil(1970,1,1,params[:user_delay][:hour].to_i,params[:user_delay][:minute].to_i,params[:user_delay][:second].to_i).strftime('%a, %d %b %Y %H:%M:%S UTC')
      user_delay_item.save

      redirect_to :action=>'index'
    else
      render :template => "public/404",  :status => 404
    end
  end
  # POST /admin/send_passwords
  def send_passwords
    users = User.where(:admin=>false)
    @email_errors = []
    @emails = []
    for user in users do
      email = Registration.password_mail(user,request.host)
      if email.deliver.errors.any? then
        mail.deliver.errors.full_messages.each do | msg |
          @email_errors = @email_errors + [msg]
        end
      else
        @emails = @emails + [user.email]
      end
    end
    if @email_errors.length > 0 then
      render 'admin/email_fail'
    else
      render 'admin/email_sended'
    end
  end
end
