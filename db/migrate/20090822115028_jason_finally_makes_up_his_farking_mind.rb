class JasonFinallyMakesUpHisFarkingMind < ActiveRecord::Migration
  def self.up
    rename_table :omnoms,  :noms
    rename_table :ballots, :omnoms
    rename_column :pplz, :voted_candidate_id, :voted_nom_id
  end

  def self.down
    rename_column :pplz, :voted_nom, :voted_candidate
    rename_table :omnoms, :ballots
    rename_table :noms,   :omnoms
  end
end
