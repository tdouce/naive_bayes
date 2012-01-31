class Individual < ActiveRecord::Base

  after_update :untrain

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

  private

  def untrain 
    self.trained = false
  end
end
