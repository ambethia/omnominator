class Nom < ActiveRecord::Base
  belongs_to :omnom
  
  validates_presence_of :name
end
