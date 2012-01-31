class Individual < ActiveRecord::Base

  validates :height, :presence => true, :numericality => true
  validates :weight, :presence => true, :numericality => true
  validates :gender, :presence => true

  MALE    = 'Male'
  FEMALE  = 'Female'

  MALEPROB   = 0.5
  FEMALEPROB = 0.5

  GENDERS = [ MALE, FEMALE ]

  scope :untrained, Individual.where( :trained => false )
  scope :gender, lambda { |gender| where("gender = ?", gender ) }

  def untrain 
    self.update_attributes( :trained => false )
  end
end
