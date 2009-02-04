class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :text, :text
      t.column :user_id, :integer
      t.column :entity_id, :integer
      t.column :karma, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
