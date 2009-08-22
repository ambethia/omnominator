class CreateVoters < ActiveRecord::Migration
  def self.up
    create_table :voters do |t|
      t.string    :email
      t.integer   :voted_candidate_id
      t.string    :activation_code

      t.timestamps
    end
  end

  def self.down
    drop_table :voters
  end
end
