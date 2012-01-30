class Individual < ActiveRecord::Base

  validates :height, :presence => true, :numericality => true
  validates :weight, :presence => true, :numericality => true
  validates :gender, :presence => true

  MALE    = 'Male'
  FEMALE  = 'Female'

  MALEPROB   = 0.5
  FEMALEPROB = 0.5

  GENDERS = [ MALE, FEMALE ]


  # user
  # scope :untrained, where( :trained => false )
  scope :untrained, Individual.where( :trained => false )

  scope :gender, lambda { |gender| where("gender = ?", gender ) }

  ## Get all individuals according to a specific gender
  #def self.gender( gender )
  #  Individual.where( :gender => gender )
  #end

  def set_trained_status_false
    self.update_attributes( :trained => false )
  end

  def set_trained_status_true
    self.update_attributes( :trained => true )
  end

  def self.to_trained( not_trained_individuals )

    # Does this belong in controller?
    not_trained_individuals.all.each {|indiv| indiv.set_trained_status_true }

  end

  #def self.get_attributes_per_gender( per_gender, attributes )
  #  Individual.select(attributes.join(',')).
  #  where(:gender => per_gender)
  #end

    #private

  #def set_trained_status_false
  #  self.update_attributes( :trained => false )
  #end


end
