class AddImagePropToEntity < ActiveRecord::Migration
  def self.up
    add_column :entities, :photo_ext, :string
    add_column :entities, :photo_width, :string
    add_column :entities, :photo_height, :string
    add_column :entities, :photo_filename, :string
  end

  def self.down
    remove_column :entities, :photo_ext
    remove_column :entities, :photo_width
    remove_column :entities, :photo_height
    remove_column :entities, :photo_filename
  end
end
