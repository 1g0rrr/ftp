class BlogController < ApplicationController

  layout "main"

  def index

    page_size = 3
    page = Integer(params[:page])
    count_of_ent = DevBlogPost.count(:all,
                                     :conditions => "")
    count_of_pages = count_of_ent / page_size + 1

    # если страница не передана, то просматриваем последнюю
    if (page == 0) then page = count_of_pages end

    @posts = DevBlogPost.find(:all,
                              :conditions => "",
                              :order => "created_at DESC",
                              :offset => (count_of_pages - page) * page_size,
                              :limit => page_size)

  end

  def view
    @post = DevBlogPost.find_by_id(params[:id])
  end

  def edit
  end

  def del
  end

  def add

    if request.post?
      @post = DevBlogPost.new(params[:post])
      if @post.save
        flash[:notice] = "Post #{@post.title} created"
        redirect_to :action => :index
      else
       flash[:notice] = "Not created"
      end
    else
      @post = DevBlogPost.new
    end

  end

  # добавляем комент в 
  def add_comment
    com = DevBlogComment.new(params[:comment])
    com.save

    flash[:notice] = "Каммент добавлен"
    redirect_to :controller => :blog, :action => :view, :id => params[:comment][:dev_blog_post_id]
  end


end
