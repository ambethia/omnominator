class AddNameToPpl < ActiveRecord::Migration
  def self.up
    add_column :pplz, :name, :string, :null => true
  end

  def self.down
    remove_column :pplz, :name
  end
end
