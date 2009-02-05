class EntitiesController < ApplicationController
  
  require "ftools"
  
  layout "main"
  
  before_filter :kick_not_user, :only => [:add, :add_comment]
  before_filter :kick_not_moder, :only => [:show_new, :edit, :del, :submit]

  def index
    
    # количество фильмов на страницу
    page_size = 3
    
    cur_page = Integer(params[:page])

    count_of_ent = Entity.count(:all, :conditions => ['is_submit = ? AND is_transfer = ?', 1, 1]) # количество выводимых сущностей
    count_of_pages = (count_of_ent.to_f / page_size).ceil # считаем количество страниц вывода


    # если страница не передана, то просматриваем последнюю
    if (cur_page == 0) then cur_page = count_of_pages end

    if (cur_page > count_of_pages)
      flash[:notice] = "Такой страницы не существует"
      @entities = ''
      return false
    end
    
    @entities = Entity.find(:all,
                            :conditions => ['is_submit = ? AND is_transfer = ?', 1, 1],
                            :order => session[:entities_sort],
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
  
  # просмотр неподтвержденных фильмов
  def show_new
    
    # количество фильмов на страницу
    page_size = 3

    cur_page = Integer(params[:page])

    count_of_ent = Entity.count(:all, :conditions => 'is_submit IS NULL') # количество выводимых сущностей
    count_of_pages = (count_of_ent.to_f / page_size).ceil # считаем количество страниц вывода

    # если страница не передана, то просматриваем последнюю
    if (cur_page == 0) then cur_page = count_of_pages end

    if (cur_page > count_of_pages)
      flash[:notice] = "Такой страницы не существует"
      @entities = ''
      return false
    end
    
    
    @entities = Entity.find(:all,
                            :conditions => 'is_submit IS NULL',
                            :order => session[:entities_sort],
                            :offset => (count_of_pages - cur_page) * page_size,
                            :limit => page_size)

    if count_of_pages > 1 then # нужна ли вообще навигация
      if cur_page > 2 then @dprev_page = cur_page - 2 end
      if cur_page > 1 then @prev_page = cur_page - 1 end
      @cur_page = cur_page
      if count_of_pages >= (cur_page + 1) then @next_page = cur_page + 1 end
      if count_of_pages >= (cur_page + 2) then @dnext_page = cur_page + 2 end
    end
    
  end
  
  # поиск по фильмам
  def search
    # количество фильмов на странице
    page_size = 20
    word = params[:word]
    @entities = Entity.find(:all,
                            :conditions => ['title like ? and is_submit = ? and is_transfer = ?', '%' + word + '%', 1, 1],
                            :order => 'title ASC',
                            :limit => page_size)
  end
  
  # добавление фильма
  def add

    if request.post?
      @params = params
      ent = Entity.new(params[:ent])
      
      if ent[:photo] != ''
        # Создаем уменьшенную копию присланного изображения
        thumb = Magick::Image.read(ent[:photo].path).first
        thumb.resize_to_fit!(200, 1000)
        thumb.thumbnail!(1)
        ent[:photo_width], ent[:photo_height] = thumb.columns, thumb.rows
      end
      
      # И сохраняем ее по соответствующему пути, который содержит id нашей Entity
      if ent.save
        if ent[:photo] != ''
          File.makedirs("#{IMAGES_STORAGE_PATH}/entities/#{ent[:id]}")
          thumb.write("#{IMAGES_STORAGE_PATH}/entities/#{ent[:id]}/ent#{ent[:id]}_w#{thumb.columns}.jpg")
        
          # Сохраняем путь к нашему изображению на сервере в БД
          ent.update_attributes(:photo => "#{IMAGES_STORAGE_PATH}/entities/#{ent[:id]}")
        end
        
        flash[:notice] = "Фильм #{ent.title} успешно добавлен, и отправлен на проверку модераторами"
        redirect_to :controller => 'entities', :action => 'index'
      else
        flash[:notice] = "Not created"
      end
    else
      begin
        uploads = Dir.entries(FILMS_UPLOAD_PATH)
        uploads.delete("..")
        uploads.delete(".")
        @uploads = uploads
      rescue
        flash[:notice] = "Папка uploads не настроена. Исправьте FILMS_UPLOAD_PATH в файле config/initializers/globals.rb на существующую директорию. И перегрузите сервер."
        redirect_to :controller => 'entities', :action => 'index'
      end
    end
  end
  
  # просмотр одного фильма
  def view
    @ent = Entity.find_by_id(params[:id])
    unless @ent
      flash[:notice] = "Данного фильма не существует"
      redirect_to :controller => 'entities', :action => 'index'
    end
  end
  
  # редактирование фильма
  def edit
    if request.post?
      ent = params[:ent]
      
      if ent[:photo] != ''
        # Создаем уменьшенную копию присланного изображения
        thumb = Magick::Image.read(ent[:photo].path).first
        thumb.resize_to_fit!(200, 1000)
        thumb.thumbnail!(1)
        ent[:photo_width], ent[:photo_height] = thumb.columns, thumb.rows
        File.makedirs("#{IMAGES_STORAGE_PATH}/entities/#{params[:id]}")
        thumb.write("#{IMAGES_STORAGE_PATH}/entities/#{params[:id]}/ent#{params[:id]}_w#{thumb.columns}.jpg")
        
        # Сохраняем путь к нашему изображению на сервере в БД
        ent[:photo] = "#{IMAGES_STORAGE_PATH}/entities/#{params[:id]}"
      else
        ent.delete(:photo)
      end
      
      @ent = Entity.find_by_id(params[:id])
      # И сохраняем ее по соответствующему пути, который содержит id нашей Entity
      if @ent.update_attributes(ent)
        flash[:notice] = "Фильм \"#{ent[:title]}\" успешно изменен"
        redirect_to :controller => 'entities', :action => 'index'
      else
        flash[:notice] = "Not created"
      end
    else
      @ent = Entity.find_by_id(params[:id])
      @ent.photo = ''
    end  
  end
  
  # удаление
  def del
    
    @ent = Entity.find_by_id(params[:id])
    @ent.update_attributes(:is_transfer => -1)
    
    flash[:notice] = "Удаление выполнено"
    redirect_to :action => :index
  end
  
  # добавляем комент в обсуждение фильма
  def add_comment
    com = Comment.new(params[:comment])
    com.save
    
    flash[:notice] = "Каммент типа добавлен"
    redirect_to :controller => :entities, :action => :view, :id => params[:comment][:entity_id]
  end
  
  # Перенос файлов на длительное хранение на другие винты
  def transfer
    @entities = Entity.find(:all, :conditions => ["is_transfer = ?", 1])
    redirect_to :action => "index"
#    while true do
      sleep(10*60)
#    end
#      render :template => 'entities/index'
#     File.makedirs("#{IMAGES_STORAGE_PATH}/entities/#{params[:id]}")
  end

  #Подтвердить фильм
  def submit
    
    ent = Entity.find_by_id(params[:id])
    ent.is_submit = 1
    ent.save
    flash[:notice] = "Успешно подтверждено, фильм будет виден, когда система его перенесёт в общее хранилище."
    redirect_to :controller => :entities, :action => :show_new
  end
  
end
