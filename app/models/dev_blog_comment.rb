class DevBlogComment < ActiveRecord::Base

  belongs_to :dev_blog_posts
  belongs_to :user

  attr_protected :karma

end
