require 'test_helper'

class ShikaiShosetuBotControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get shikai_shosetu_bot_index_url
    assert_response :success
  end

end
