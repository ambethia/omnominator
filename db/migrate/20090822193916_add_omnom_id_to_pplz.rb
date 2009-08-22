class AddOmnomIdToPplz < ActiveRecord::Migration
  def self.up
    add_column :pplz, :omnom_id, :integer
  end

  def self.down
    remove_column :pplz, :omnom_id
  end
end
