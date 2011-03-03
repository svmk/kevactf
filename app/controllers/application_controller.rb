class ApplicationController < ActionController::Base
  before_filter :verify_connection
  before_filter :show_info
  before_filter :clean_session
  rescue_from ActionController::RoutingError, :with => :record_not_found
  def show_info
    @irc = KevaConfig.where(:key => 'irc').first.value
    @email = KevaConfig.where(:key => 'email').first.value
    @game_enabled = KevaConfig.where(:key => 'game_enabled').first.value == "Enabled"
    @register_enabled = KevaConfig.where(:key => 'register_enabled').first.value == "Enabled"
    @countdown = KevaConfig.where(:key => 'countdown').first.value == "Enabled"

    register_end_str = KevaConfig.where(:key => 'register_end').first.value
    if register_end_str!='' then
      @register_end_time = DateTime.parse(register_end_str)
      #@register_end = @register_end_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    else
      @register_end_time = DateTime.now
      #@register_end = ''
    end

    game_begin_str = KevaConfig.where(:key => 'game_begin').first.value
    if game_begin_str!='' then
      @game_begin_time = DateTime.parse(game_begin_str)
      #@game_begin = @game_begin_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    else
      @game_begin_time = DateTime.now
      #@game_begin = ''
    end
    game_end_str = KevaConfig.where(:key => 'game_end').first.value
    if game_end_str != '' then
      @game_end_time = DateTime.parse(game_end_str)
      @game_end = @game_end_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    else
      @game_end_time = DateTime.now
      @game_end = ''
    end

    
    @admin = session[:admin]
    @logged_in = session[:logged]
  end
  def clean_session
    #session.sweep("8 hours")
  end
  private
  def record_not_found
    render :template => "public/404",  :status => 404
  end
  protect_from_forgery
end
