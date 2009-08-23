class AddOmnomIdToNom < ActiveRecord::Migration
  def self.up
    add_column :noms, :omnom_id, :integer
  end

  def self.down
    remove_column :noms, :omnom_id
  end
end
