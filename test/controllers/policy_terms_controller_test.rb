require "test_helper"

class PolicyTermsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @policy_term = policy_terms(:one)
  end

  test "should get index" do
    get policy_terms_url
    assert_response :success
  end

  test "should get new" do
    get new_policy_term_url
    assert_response :success
  end

  test "should create policy_term" do
    assert_difference("PolicyTerm.count") do
      post policy_terms_url, params: { policy_term: { active: @policy_term.active, content: @policy_term.content, version: @policy_term.version } }
    end

    assert_redirected_to policy_term_url(PolicyTerm.last)
  end

  test "should show policy_term" do
    get policy_term_url(@policy_term)
    assert_response :success
  end

  test "should get edit" do
    get edit_policy_term_url(@policy_term)
    assert_response :success
  end

  test "should update policy_term" do
    patch policy_term_url(@policy_term), params: { policy_term: { active: @policy_term.active, content: @policy_term.content, version: @policy_term.version } }
    assert_redirected_to policy_term_url(@policy_term)
  end

  test "should destroy policy_term" do
    assert_difference("PolicyTerm.count", -1) do
      delete policy_term_url(@policy_term)
    end

    assert_redirected_to policy_terms_url
  end
end
