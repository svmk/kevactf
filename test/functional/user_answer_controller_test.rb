require 'test_helper'

class UserAnswerControllerTest < ActionController::TestCase
  test "should get answer" do
    get :answer
    assert_response :success
  end

end
