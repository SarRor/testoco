require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get inicio" do
    get home_inicio_url
    assert_response :success
  end

end
