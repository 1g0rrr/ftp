class UsersController < ApplicationController
  
  before_filter :kick_not_user, :except => [:login, :register]
  before_filter :kick_not_moder, :except => [:view, :login, :register, :edit, :logout, :add]
  before_filter :kick_not_owner, :only => [:edit]
  
  
  layout "main"
  
  def index
    
    # количество юзверей на страницу
    page_size = 10
    
    cur_page = Integer(params[:page])
    
    count_of_ent = User.count(:all) # количество выводимых сущностей
    count_of_pages = (count_of_ent.to_f / page_size).ceil # считаем количество страниц вывода
    
    # если страница не передана, то просматриваем последнюю
    if (cur_page == 0) then cur_page = count_of_pages end

    if (cur_page > count_of_pages)
      flash[:notice] = "Такой страницы не существует"
      @users = ''
      return false
    end

    @users = User.find(:all,
                       :order => session[:users_sort],
                       :offset => (count_of_pages - cur_page) * page_size,
                       :limit => page_size)
                       
    # cur_page - страница которую пользователь запрашивает и на которую хочет перейти
    # next_page - следующай страница (большая по счету)
    # prev_page - предыдущая страница (меньшая по счету)
    # dnext_page - предыдущая через одну страница
    # dprew_page - следующая через одну страница
    
    if count_of_pages > 1 then # нужна ли вообще навигация
      if cur_page > 2 then @dprev_page = cur_page - 2 end
      if cur_page > 1 then @prev_page = cur_page - 1 end
      @cur_page = cur_page
      if count_of_pages >= (cur_page + 1) then @next_page = cur_page + 1 end
      if count_of_pages >= (cur_page + 2) then @dnext_page = cur_page + 2 end
    end
                       
  end
  
  def add
    if request.post?
      @user = User.new(params[:user])
      if @user.save
        flash[:notice] = "Пользователь #{@user.uname} создан"
        redirect_to :action => :index
      else
        flash[:notice] = "Невозможно создать пользователя с таким ником"
      end
    else
      @user = User.new
    end
  end
  
  def view
    @user = User.find_by_id(params[:id])
    unless @user
      flash[:notice] = "Такой пользователь не найден"
      redirect_to :controller => 'entities', :action => 'index'
    end
  end
  
  def edit
    if request.post?
      user = params[:user]
      user[:password] == '' ? user.delete(:password) : ''

      if user[:photo] != ''
        thumb = Magick::Image.read(user[:photo].path).first
        thumb.resize_to_fit!(100, 113)
        thumb.thumbnail!(1)
        File.makedirs("#{IMAGES_STORAGE_PATH}/users/#{params[:id]}")
        thumb.write("#{IMAGES_STORAGE_PATH}/users/#{params[:id]}/user#{params[:id]}_w#{thumb.columns}.jpg")
        user[:photo] = "#{IMAGES_STORAGE_PATH}/users/#{params[:id]}"
        # user[:photo_width], ent[:photo_height] = thumb.columns, thumb.rows
        
      else
        user.delete(:photo)
      end
      @user = User.find_by_id(params[:id])
      
      if @user.update_attributes(user)
        flash[:notice] = "User #{@user.uname} saved"
        redirect_to :controller => "users", :action => "view", :id => @user.id
      else
        flash[:notice] = "Невозможно сохранить пользователя"
      end
      #     Создаем уменьшенную копию присланного изображения

    else
      begin
        @user = User.find_by_id(params[:id])
        @user.password = ''
        @user.photo = ''
      rescue
        flash[:notice] = "Такой пользователь не найден"
#        redirect_to :controller => 'entities', :action => 'index'
      end
    end
  end
  
  def del
    @user = User.find_by_id(params[:id])
    @user.destroy
    
    flash[:notice] = "Удаление выполнено"
    redirect_to :action => :index
  end
  
  def login

    if @is_user
      flash[:notice] = 'Вы уже вошли под вашим именем'
      redirect_to(:action => "index", :controller => "entities")
    end
    
    if request.post?
      user = User.authenticate(params[:uname], params[:password])
      if user
        session[:user] = user
        redirect_to(:action => "index", :controller => "entities")
      else
        flash[:notice] = 'Не-не-не, ' + params[:uname] + ', не-не-не!!! O_o '
      end
    end
  end
  
  def logout
    session[:user] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "index", :controller => "entities")
  end
  
  def register
    if @is_user
      flash[:notice] = 'Перед регистрацией нового пользователя нужно выйти из системы'
      redirect_to(:action => "index", :controller => "entities")
    end

    if request.post?
      if(params[:user][:password] == params[:user][:password_confirmation])

        params[:user][:password] = User::encrypted_password(params[:user][:password])
        user = User.new(params[:user])
        
        #     Создаем уменьшенную копию присланного изображения
        if user[:photo] != ''
          thumb = Magick::Image.read(user[:photo].path).first
          thumb.resize_to_fit!(100, 500)
          thumb.thumbnail!(1)
          # user[:photo_width], ent[:photo_height] = thumb.columns, thumb.rows
        end
        
        if user.save
          if user[:photo] != ''
            File.makedirs("#{IMAGES_STORAGE_PATH}/users/#{user[:id]}")
            thumb.write("#{IMAGES_STORAGE_PATH}/users/#{user[:id]}/user#{user[:id]}_w#{thumb.columns}.jpg")
            user.update_attributes(:photo => "#{IMAGES_STORAGE_PATH}/users/#{user[:id]}")
          end
          session[:user] = user
          redirect_to :action => :index, :controller => :entities
        else
          flash[:notice] = "Невозможно создать пользователя с таким ником"
        end
      else
        flash[:notice] = "Пароль и подтверждение не совпадают"
      end
    end
  end
  
end
