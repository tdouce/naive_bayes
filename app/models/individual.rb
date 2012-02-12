class Individual < ActiveRecord::Base

  before_update :untrain
  before_save   :height_to_decimal_inches

  validates :height_ft, :numericality => { :only_integer => true, :less_than_or_equal_to => 7 }
  validates :height_in, :numericality => { :less_than_or_equal_to => 11 }
  validates :weight,    :presence => true, :numericality => true
  validates :gender,    :presence => true

  MALE    = 'Male'
  FEMALE  = 'Female'

  MALEPROB   = 0.5
  FEMALEPROB = 0.5

  GENDERS = [ MALE, FEMALE ]

  scope :untrained, Individual.where( :trained => false )
  scope :gender, lambda { |gender| where("gender = ?", gender ) }

  private

  def untrain 
    self.trained = :false
  end

  def height_to_decimal_inches
      self.height_in = 0 if self.height_in.blank?
      self.height = Float( self.height_ft ) + ( Float( self.height_in )/12 )
  end

end
