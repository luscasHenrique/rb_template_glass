require "test_helper"

class TrackingIntegrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tracking_integration = tracking_integrations(:one)
  end

  test "should get index" do
    get tracking_integrations_url
    assert_response :success
  end

  test "should get new" do
    get new_tracking_integration_url
    assert_response :success
  end

  test "should create tracking_integration" do
    assert_difference("TrackingIntegration.count") do
      post tracking_integrations_url, params: { tracking_integration: { account_id: @tracking_integration.account_id, is_active: @tracking_integration.is_active, provider_name: @tracking_integration.provider_name } }
    end

    assert_redirected_to tracking_integration_url(TrackingIntegration.last)
  end

  test "should show tracking_integration" do
    get tracking_integration_url(@tracking_integration)
    assert_response :success
  end

  test "should get edit" do
    get edit_tracking_integration_url(@tracking_integration)
    assert_response :success
  end

  test "should update tracking_integration" do
    patch tracking_integration_url(@tracking_integration), params: { tracking_integration: { account_id: @tracking_integration.account_id, is_active: @tracking_integration.is_active, provider_name: @tracking_integration.provider_name } }
    assert_redirected_to tracking_integration_url(@tracking_integration)
  end

  test "should destroy tracking_integration" do
    assert_difference("TrackingIntegration.count", -1) do
      delete tracking_integration_url(@tracking_integration)
    end

    assert_redirected_to tracking_integrations_url
  end
end
