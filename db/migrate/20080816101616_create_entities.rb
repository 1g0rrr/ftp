class CreateEntities < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.column :title, :string
      t.column :photo, :string
      t.column :description, :text
      t.column :is_submit, :integer
      t.column :user_id, :integer
      t.column :category, :integer
      t.column :sub_category, :integer
      t.column :karma, :integer
      t.column :file_name, :string
      t.column :file_size, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :entities
  end
end
