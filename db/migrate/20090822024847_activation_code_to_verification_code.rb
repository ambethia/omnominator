class ActivationCodeToVerificationCode < ActiveRecord::Migration
  def self.up
    rename_column :voters, :activation_code, :verification_code
    remove_column :ballots, :activation_code
  end

  def self.down
    add_column :ballots, :activation_code, :string
    rename_column :voters, :verification_code
  end
end
