require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def setup
#    @controller = LoginController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_guest_perms
    get :login
    assert_response :success
    get :register
    assert_response :success
    get :index
    assert_response :redirect
    get :edit
    assert_response :redirect
    get :add
    assert_response :redirect
    get :view
    assert_response :redirect
    get :del
    assert_response :redirect
    get :logout
    assert_response :redirect
    
    user = users(:user)
    post :login, :uname => user.uname, :password => 'wrong'
    assert_equal nil, session[:user]
    
    post :login, :uname => user.uname, :password => 'password'
    assert_redirected_to :controller => "entities", :action => "index"
    assert_equal user.id, session[:user].id

    post :register, {:user => {:uname => 'newuser', :password => 'password', :password_confirmation => 'wrong', :photo => ''}}, {}
    newuser = User.find_by_uname('newuser')
    assert_equal nil, newuser
    assert_equal nil, session[:user]

    post :register, {:user => {:uname => 'newuser', :password => 'password', :password_confirmation => 'password', :photo => ''}}, {}
    newuser = User.find_by_uname('newuser')
    assert_equal session[:user], newuser

  end
  
  def test_user_perms
    get :index, {}, {:user => users(:user)}
    assert_response :redirect
    get :view, {:id => users(:user).id}, {:user => users(:user)}
    assert_response :success
    get :view, {:id => 123123123}, {:user => users(:user)} # Просмотр юзера слевым id-шником
    assert_response :redirect
    get :add, {}, {:user => users(:user)}
    assert_response :redirect
    get :edit, {:id => users(:user).id}, {:user => users(:user)}
    assert_response :success
    get :edit, {:id => users(:moder).id}, {:user => users(:user)} # Редактирование чужого профиля
    assert_response :redirect
    get :del, {:id => users(:user).id}, {:user => users(:user)}
    assert_response :redirect
    get :login, {}, {:user => users(:user)}
    assert_response :redirect
    get :logout, {}, {:user => users(:user)}
    assert_equal session[:user], nil
    get :register, {}, {:user => users(:user)}
    assert_response :redirect
  end

  def test_moder_perms
    get :index, {}, {:user => users(:moder)}
    assert_response :success
    get :add, {}, {:user => users(:moder)}
    assert_response :success
  end
end
