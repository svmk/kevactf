class NewsController < ApplicationController
  # GET /news
  def index
    @news = NewsItem.all()
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /news/1
  def show
    @news_item = NewsItem.find(params[:id])
    @comments = @news_item.comment
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /news/new
  def new
    if session[:admin] then
      @news_item = NewsItem.new

      respond_to do |format|
        format.html # new.html.erb
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /news/1/edit
  def edit
    if session[:admin] then
      @news_item = NewsItem.find(params[:id])
    else
      render :template => "public/404",  :status => 404
    end
  end

  # POST /news/create
  def create
    if session[:admin] then
      @news_item = NewsItem.new(:title=>params[:title],:content=>params[:content],:user_id=>session[:user_id])
      respond_to do |format|
        if @news_item.save
          format.html { redirect_to :action=>'show',:id=>@news_item.id }
        else
          format.html { render :action => "new" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # PUT /news/1/update
  def update
    if session[:admin] then
      @news_item = NewsItem.find(params[:id])

      respond_to do |format|
        if @news_item.update_attributes(:content=>params[:content],:title=>params[:title],:user_id=>session[:user_id])
          format.html { redirect_to(:action=>'show',:id=>@news_item.id) }
        else
          format.html { render :action => "edit" }
        end
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # DELETE /news/1
  def destroy
    if session[:admin] then
      @news_item = NewsItem.find(params[:id])
      @news_item.destroy

      respond_to do |format|
        format.html { redirect_to(:action=>'index') }
      end
    else
      render :template => "public/404",  :status => 404
    end
  end

  # GET /news/1#comments
  def comments
    kevaconf = KevaConfig.where(:key => 'news_comments').first
    if session[:logged] then
      if kevaconf and kevaconf.value then
        @news_item = NewsItem.find(params[:id])
        respond_to do |format|
          format.html
        end
      else
        render :template => "public/404",  :status => 404
      end
    end
  end

  # GET /news/1/add_comment
  def new_comment
    kevaconf = KevaConfig.where(:key => 'news_comments').first
    if session[:logged] then
      if kevaconf and kevaconf.value then
        @news_item = NewsItem.find(params[:id])
        @comment = Comment.new
        respond_to do |format|
          format.html
        end
      else
        render :template => "public/404",  :status => 404
      end
    else
      redirect_to :controller => 'auth', :action => 'index'
    end
  end

  # POST /news/1/create_comment
  def create_comment
    kevaconf = KevaConfig.where(:key => 'news_comments').first
    if session[:logged] then
      if kevaconf and kevaconf.value then
        @news_item = NewsItem.find(params[:id])
        @comment = @news_item.comment.new(:title=>params[:comment_title],
          :content=>params[:comment_content],:user_id => session[:user_id])
        if @comment.save then
          redirect_to :action=>'show',:id=>params[:id],:controller=>'news'
        else
          render :action=>'new_comment'
        end
      else
        render :template => "public/404",  :status => 404
      end
    else
      redirect_to :controller => 'auth', :action => 'index'
    end
  end

  # DELETE /news/1/comment/1/remove_comment
  def remove_comment
    if session[:admin] then
      comment = Comment.find(params[:id])
      comment.destroy
      respond_to do |format|
        format.html { redirect_to(:action=>'show',:id=>params[:news_id]) }
      end
    else
      render :template => "public/404",  :status => 404
    end
  end
end
