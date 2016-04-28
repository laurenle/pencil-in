require 'test_helper'

class ListControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get order" do
    get :order
    assert_response :success
  end

end
