require 'test_helper'

class UploadedUsersControllerTest < ActionController::TestCase
  setup do
    @uploaded_user = uploaded_users(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:uploaded_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create uploaded_user" do
    assert_difference('UploadedUser.count') do
      post :create, uploaded_user: { approved_by_id: @uploaded_user.approved_by_id, batch_id: @uploaded_user.batch_id, created_by_id: @uploaded_user.created_by_id, email: @uploaded_user.email, first_name: @uploaded_user.first_name, grade: @uploaded_user.grade, last_name: @uploaded_user.last_name, message: @uploaded_user.message, password: @uploaded_user.password, person_id: @uploaded_user.person_id, school_id: @uploaded_user.school_id, state: @uploaded_user.state, type: @uploaded_user.type, username: @uploaded_user.username }
    end

    assert_redirected_to uploaded_user_path(assigns(:uploaded_user))
  end

  test "should show uploaded_user" do
    get :show, id: @uploaded_user
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @uploaded_user
    assert_response :success
  end

  test "should update uploaded_user" do
    put :update, id: @uploaded_user, uploaded_user: { approved_by_id: @uploaded_user.approved_by_id, batch_id: @uploaded_user.batch_id, created_by_id: @uploaded_user.created_by_id, email: @uploaded_user.email, first_name: @uploaded_user.first_name, grade: @uploaded_user.grade, last_name: @uploaded_user.last_name, message: @uploaded_user.message, password: @uploaded_user.password, person_id: @uploaded_user.person_id, school_id: @uploaded_user.school_id, state: @uploaded_user.state, type: @uploaded_user.type, username: @uploaded_user.username }
    assert_redirected_to uploaded_user_path(assigns(:uploaded_user))
  end

  test "should destroy uploaded_user" do
    assert_difference('UploadedUser.count', -1) do
      delete :destroy, id: @uploaded_user
    end

    assert_redirected_to uploaded_users_path
  end
end
