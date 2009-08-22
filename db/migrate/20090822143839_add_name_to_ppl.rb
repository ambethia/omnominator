class AddNameToPpl < ActiveRecord::Migration
  def self.up
    add_column :ppl, :name, :string, :null => true
  end

  def self.down
    remove_column :ppl, :name
  end
end
