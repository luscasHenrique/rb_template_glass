require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    # 1. Fabricamos o usuário e fazemos login nele (Bypass do Devise)
    @user = create(:user, :admin)
    sign_in @user

    # 2. Fabricamos o perfil e amarramos ao usuário que acabamos de criar
    @profile = create(:profile, user: @user)
  end

  test "should get index" do
    get profiles_url
    assert_response :success
  end

  test "should get new" do
    get new_profile_url
    assert_response :success
  end

  test "should create profile" do
    assert_difference("Profile.count") do
      # Simulamos o preenchimento do formulário com dados limpos e o ID do usuário logado
      post profiles_url, params: { profile: { first_name: "Nome", last_name: "Teste", bio: "Nova Bio", phone: "11999999999", user_id: @user.id } }
    end

    assert_redirected_to profile_url(Profile.last)
  end

  test "should show profile" do
    get profile_url(@profile)
    assert_response :success
  end

  test "should get edit" do
    get edit_profile_url(@profile)
    assert_response :success
  end

  test "should update profile" do
    # Validamos se o sistema aceita a edição de um dado (ex: atualizando o nome)
    patch profile_url(@profile), params: { profile: { first_name: "Nome Editado" } }
    assert_redirected_to profile_url(@profile)
  end

  test "should destroy profile" do
    assert_difference("Profile.count", -1) do
      delete profile_url(@profile)
    end

    assert_redirected_to profiles_url
  end
end