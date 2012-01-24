class Individual < ActiveRecord::Base

  MALE   = 'male'
  FEMALE = 'female'

  validates :height, :presence => true, :numericality => true
  validates :weight, :presence => true, :numericality => true
  validates :gender, :presence => true

  GENDERS = [MALE, FEMALE]
end
