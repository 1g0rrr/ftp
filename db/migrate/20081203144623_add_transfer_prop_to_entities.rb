class AddTransferPropToEntities < ActiveRecord::Migration
  def self.up
    add_column :entities, :is_transfer, :integer
  end

  def self.down
    remove_column :entities, :is_transfer
  end
end

