require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Fabricamos um admin dinâmico e já fazemos o login!
    @admin = create(:user, :admin)
    sign_in @admin
  end

  test "should get index" do
    get root_url
    assert_response :success
  end
end
