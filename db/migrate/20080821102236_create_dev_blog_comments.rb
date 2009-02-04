class CreateDevBlogComments < ActiveRecord::Migration
  def self.up
    create_table :dev_blog_comments do |t|
      t.column :text, :text
      t.column :user_id, :integer
      t.column :dev_blog_post_id, :integer
      t.column :karma, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :dev_blog_comments
  end
end
