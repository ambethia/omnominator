class AddActivatedAtToOmnom < ActiveRecord::Migration
  def self.up
    add_column :omnoms, :activated_at, :datetime
  end

  def self.down
    remove_column :omnoms, :activated_at
  end
end
