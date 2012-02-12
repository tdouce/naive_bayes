class Individual < ActiveRecord::Base

  include NaiveBayesClassifier

  before_update :untrain
  before_save   :height_to_decimal_inches

  validates :weight,    :presence => true, :numericality => { :greater_than => 50, :less_than_or_equal_to => 400 }
  validates :height_ft, :numericality => { :only_integer => true, :less_than_or_equal_to => 7 }
  validates :height_in, :numericality => { :less_than_or_equal_to => 11 }, :allow_blank => true
  validates :foot_size, :presence => true, :numericality => { :greater_than => 4, :less_than_or_equal_to => 17 }
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
end
