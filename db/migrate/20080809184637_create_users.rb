class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :uname, :string
      t.column :real_name, :string
      t.column :second_name, :string
      t.column :sex, :integer
      t.column :about, :text
      t.column :birthday, :date
      t.column :icq, :string
      t.column :email, :string
      t.column :photo, :string
      t.column :perms, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
