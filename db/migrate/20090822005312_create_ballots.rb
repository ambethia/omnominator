class CreateBallots < ActiveRecord::Migration
  def self.up
    create_table :ballots do |t|
      t.string     :owner_email
      t.string     :activation_code
      t.boolean    :approved

      t.timestamps
    end
  end

  def self.down
    drop_table :ballots
  end
end
