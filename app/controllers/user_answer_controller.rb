class UserAnswerController < ApplicationController
  def answer
    if session[:admin] then
      @answers = UserAnswer.all
    else
      render :template => "public/404",  :status => 404
    end
  end
end
