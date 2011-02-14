class MainPageController < ApplicationController
  # GET /
  def index
    DateTime.parse().strftime("%Y-%m-%d %H:%M:%S UTC")
    @register_enabled = KevaConfig.where(:key => 'register_enabled').first.value == "Enabled"
    @game_enabled = KevaConfig.where(:key => 'game_enabled').first.value == "Enabled"

    register_end_str = KevaConfig.where(:key => 'register_end').first.value
    if register_end_str!='' then
      @register_end_time = DateTime.parse(register_end_str)
      @register_end = @register_end_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    else
      @register_end_time = DateTime.now
      @register_end = ''
    end
    
    game_begin_str = KevaConfig.where(:key => 'game_begin').first.value
    if game_begin_str!='' then
      @game_begin_time = DateTime.parse(game_begin_str)
      @game_begin = @game_begin_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    else
      @game_begin_time = DateTime.now
      @game_begin = ''
    end
    game_end_str = KevaConfig.where(:key => 'game_end').first.value
    if game_end_str != '' then
      @game_end_time = DateTime.parse(game_end_str)
      @game_end = @game_end_time.strftime("%Y-%m-%d %H:%M:%S UTC")
    else
      @game_end_time = DateTime.now
      @game_end = ''
    end
    @main_page_content = KevaConfig.where(:key => 'main_page_content').first.value
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
