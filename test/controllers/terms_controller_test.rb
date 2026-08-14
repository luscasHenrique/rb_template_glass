require "test_helper"

class TermsControllerTest < ActionDispatch::IntegrationTest
  test "should get pending" do
    get terms_pending_url
    assert_response :success
  end

  test "should get accept" do
    get terms_accept_url
    assert_response :success
  end
end
