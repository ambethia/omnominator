class Candidate < ActiveRecord::Base
  belongs_to :ballot
  
  validates_presence_of :name
end
