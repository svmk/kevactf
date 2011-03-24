require "base64"
class QuestsController < ApplicationController
  
  # GET /quests
  def index
    game_begin_str = KevaConfig.where(:key => 'game_begin').first.value
    if DateTime.now > ((game_begin_str!='') ?
          DateTime.parse(game_begin_str) :
          DateTime.now) and
        KevaConfig.where(:key=>'game_enabled').first.value == 'Enabled' or
        session[:admin] then
      @quests = Quest.order("price ASC,quest_type_id ASC").all
      @quest_types = QuestType.order("id ASC")
      respond_to do |format|
        format.html # index.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /quests/1
  def show
    game_begin_str = KevaConfig.where(:key => 'game_begin').first.value
    if session[:logged] and DateTime.now > ((game_begin_str!='') ?
          DateTime.parse(game_begin_str) :
          DateTime.now) and
        KevaConfig.where(:key=>'game_enabled').first.value == 'Enabled' or
        session[:admin] then
      if not User.find(session[:user_id]).enabled then
        redirect_to :controller=>'auth',:action=>'logout'
        return
      end
      if Quest.exists?(params[:id]) then
        @quest = Quest.find(params[:id])
        if not @quest.show then
          redirect_to :action=>'index'
          return
        end
        if @quest.user.where(:id => session[:user_id]).count > 0 then
          render 'quests/already_done'
          return
        end
        @hints = @quest.hint
        respond_to do |format|
          format.html # show.html.erb
        end
      else
        redirect_to :action=>'index'
      end
    else
      redirect_to :controller=>'auth',:action=>'index'
    end
  end

  # GET /quests/new
  def new
    if session[:admin] then
      if QuestType.count > 0 then
        @quest = Quest.new
        respond_to do |format|
          format.html # new.html.erb
        end
      else
        redirect_to :action=>'new',:controller=>'quest_types'
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /quests/1/edit
  def edit
    if session[:admin] and Quest.exists?(params[:id]) then
      @quest = Quest.find(params[:id])
    else
      render :template => "public/404",  :status => 404
    end
  end

  # POST /quests
  def create
    if session[:admin] then
      @quest = Quest.new(params[:quest])
      respond_to do |format|
        if @quest.save
          format.html { redirect_to(@quest, :notice => 'Quest was successfully created.') }
        else
          format.html { render :action => "new" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # PUT /quests/1
  def update
    if session[:admin] and Quest.exists?(params[:quest][:id]) then
      @quest = Quest.find(params[:id])
      respond_to do |format|
        if @quest.update_attributes(params[:quest])
          format.html { redirect_to(@quest, :notice => 'Quest was successfully updated.') }
        else
          format.html { render :action => "edit" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # DELETE /quests/1/delete
  def destroy
    if session[:admin] and Quest.exists?(params[:id]) then
      @quest = Quest.find(params[:id])
      @quest.destroy
      respond_to do |format|
        format.html { redirect_to(quests_url) }
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # POST /quests/1/answer
  def answer
    if not session[:logged] then
      redirect_to :controller=>'auth',:action=>'index'
      return
    end
    game_begin_str = KevaConfig.where(:key => 'game_begin').first.value
    if session[:logged] and DateTime.now > ((game_begin_str!='') ?
          DateTime.parse(game_begin_str) :
          DateTime.now) and
        KevaConfig.where(:key=>'game_enabled').first.value == 'Enabled' or session[:admin] then
      if User.exists?(session[:user_id]) then
        user = User.find(session[:user_id])
        logger.debug "User -------------------------------------- #{user.inspect}"
        if not user.enabled then
          redirect_to :controller=>'auth',:action=>'logout'
          return
        end
        timeout_item = DateTime.parse(KevaConfig.where(:key=>'user_delay').first.value)
        if (user.last_time + timeout_item.hour.hours + timeout_item.min.minutes +
            timeout_item.sec.seconds) > DateTime.now then
          render 'quests/timeout'
          return
        else
          user.last_time = DateTime.now
        end
        if Quest.exists?(params[:id]) and user.enabled  then
          @quest = Quest.find(params[:id])
          if @quest.user.where(:id => session[:user_id]).count > 0 then
            render 'quests/already_done'
            return 
          end
          answer = Base64.encode64(params[:answer].strip.upcase)
          quest_done = (system(@quest.syscmd.to_s + ' ' + answer.strip.to_s) == 1)
          if quest_done and not @quest.user.exists?(session[:user_id]) then
            @quest.user = @quest.user + [user]
            user.price = user.price + @quest.price
          end
          user.save
          respond_to do |format|
            if quest_done then
              format.html {render :action => 'good_answer'}
            else
              format.html {render :action => 'bad_answer'}
            end
          end
        else
          render :template => "public/404",  :status => 404
        end
      end
    end
  end
end
