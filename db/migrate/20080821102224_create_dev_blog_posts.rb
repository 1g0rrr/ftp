class CreateDevBlogPosts < ActiveRecord::Migration
  def self.up
    create_table :dev_blog_posts do |t|
      t.column :title, :string
      t.column :text, :text
      t.column :user_id, :integer
      t.column :is_hide, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :dev_blog_posts
  end
end
