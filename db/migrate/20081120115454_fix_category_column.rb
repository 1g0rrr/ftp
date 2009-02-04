class FixCategoryColumn < ActiveRecord::Migration
  def self.up
    change_column  :entities, :category, :string 
  end

  def self.down
    change_column :entities, :category, :integer
  end
end
