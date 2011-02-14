class QuestTypesController < ApplicationController
  
  # GET /quest_type/new
  def new
    if session[:admin] then
      @quest_type = QuestType.new
      respond_to do |format|
        format.html # new.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # POST /quest_type/create
  def create
    if session[:admin] then
      @quest_type = QuestType.new(:title=>params[:title],:id=>params[:id])
      respond_to do |format|
        if @quest_type.save
          format.html { redirect_to(:controller=>'quests', :notice => 'Was successfully created.') }
        else
          format.html { render :action => "new_quest_type" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /quest_type/1/edit
  def edit
    if session[:admin] then
      @quest_type = QuestType.find(params[:id])
    else
      render :template => "public/404",  :status => 404
    end
  end

  # PUT /quest_type/update
  def update
    if session[:admin] then
      @quest_type = QuestType.find(params[:id])
      respond_to do |format|
        if @quest_type.update_attributes(:title=>params[:title],:id=>params[:id])
          format.html { redirect_to(:controller=>'quests', :notice => 'Was successfully updated.') }
        else
          format.html { render :action => "edit" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # DELETE /quest_type/1/delete
  def destroy
    if session[:admin] then
      @quest_type = QuestType.find(params[:id])
      @quest_type.destroy

      respond_to do |format|
        format.html { redirect_to(quests_url) }
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /quest_type/1
  def show_quest_type
    render :template => "public/404",  :status => 404
  end

  # GET /quest_type
  def index_quest_type
    render :template => "public/404",  :status => 404
  end
end
