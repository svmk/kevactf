class MainPageController < ApplicationController
  # GET /
  def index
    @main_page_content = KevaConfig.where(:key => 'main_page_content').first.value
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end
