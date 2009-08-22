class ChangeBallotToCreatorId < ActiveRecord::Migration
  def self.up
    add_column    :ballots, :creator_id, :integer
    remove_column :ballots, :owner_email
  end

  def self.down
    add_column    :ballots, :owner_email, :string
    remove_column :ballots, :creator_id
  end
end
