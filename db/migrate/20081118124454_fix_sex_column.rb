class FixSexColumn < ActiveRecord::Migration
  def self.up
    change_column  :users, :sex, :string 
  end

  def self.down
    change_column :users, :sex, :integer
  end
end
