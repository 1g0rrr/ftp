require 'test_helper'

class UserStoriesTest < ActionController::IntegrationTest
  fixtures :users

  def test_user_stories


    get "users/login"

    assert_response :success
    assert_template "users/login"
    
    user = users(:user)
    
    post_via_redirect "users/login", :uname => user.uname, :password => 'wrong'
    assert_template "users/login"
    assert_response :success
    
    post_via_redirect "users/login", :uname => user.uname, :password => 'password'
    assert_template "entities/index"
    assert_response :success
    assert_equal session[:user].id, user.id
    
    get "entities/add"
    assert_response :success
    assert_template "entities/add"
    
    post_via_redirect "entities/add", :ent => {:title => "Новый фильм", :category => "comedy", :photo => '', :file_name => "igor.avi", :description => "Описание этого мего фильмеца", :user_id => user.id}
    assert_response :success
    assert_template "entities/index"
    e = Entity.find(:last)
    assert_equal e.title, "Новый фильм"
    
    get_via_redirect "users/logout"
    assert_response :success
    assert_template "entities/index"
    assert_equal session[:user], nil
  end

end
