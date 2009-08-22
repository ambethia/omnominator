class ForgotMySenseOfHumor < ActiveRecord::Migration
  def self.up
    rename_table :candidates, :omnoms
    rename_table :voters, :pplz
    remove_column :ballots, :approved
  end

  def self.down
    add_column :ballots, :approved, :boolean
    rename_table :pplz, :voters
    rename_table :omnoms, :candidates
  end
end
