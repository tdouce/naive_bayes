class Sample < ActiveRecord::Base

  #attr_accessible :test

  # Determine gender of a sample by using the Naive Bayes Classifier
  include NaiveBayes

  validates :weight,    :presence => true, :numericality => true
  validates :height,    :presence => true, :numericality => true
  validates :foot_size, :presence => true, :numericality => true

  def test

    #males   = Individual.males.map {|male| [ male.weight, male.height, male.foot_size ]}.transpose
    #females = Individual.males.map {|male| [ male.weight, male.height, male.foot_size ]}.transpose

    males   = Individual.get_gender(Individual::MALE).map {|male| [ male.weight, male.height, male.foot_size ]}.transpose
    females = Individual.get_gender(Individual::FEMALE).map {|female| [ female.weight, female.height, female.foot_size ]}.transpose

    training_data = {}

    # See if there is a way to dynamically build this list based on the number of items in the
    # form or possibly the number of columns (minus id, created_at, etc) that are in the database table
    training_data[ Individual::MALE ]   = males 
    training_data[ Individual::FEMALE ] = females 

    #a = GenderDecider.new()
    #a.train( training_data )
    #a.get_posteriors( sample, Individual::MALEPROB, Individual::FEMALEPROB )
    #result = a.classify( Individual::MALE, Individual::FEMALE )

    # Testing response for AJAX
    'Yes, it is!'

  end
end
