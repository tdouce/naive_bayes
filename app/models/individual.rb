class Individual < ActiveRecord::Base

  validates :height, :presence => true, :numericality => true
  validates :weight, :presence => true, :numericality => true
  validates :gender, :presence => true

  MALE    = 'Male'
  FEMALE  = 'Female'

  # Is the dynamic scope below better?
  #scope :males,   Individual.where(:gender => Individual::MALE)
  #scope :females, Individual.where(:gender => Individual::FEMALE)

  # Get all individuals according to a specific gender
  def self.get_gender(gender)
    Individual.where(:gender => gender )
  end

  MALEPROB   = 0.5
  FEMALEPROB = 0.5

  GENDERS = [MALE, FEMALE]


end
