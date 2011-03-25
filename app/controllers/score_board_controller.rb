class ScoreBoardController < ApplicationController
  # GET /scoreboard
  def index
    game_begin_str = KevaConfig.where(:key => 'game_begin').first.value
    if ((game_begin_str!='') ? DateTime.parse(game_begin_str) :
          DateTime.now) < DateTime.now or session[:admin] then
      @finished_count = Quest.where(:show => true).count
      @users = User.where(:enabled => true, :admin => false).order("price DESC")
      respond_to do |format|
        format.html # index.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end
end
