class Sample < ActiveRecord::Base

  #attr_accessible :test

  # Determine gender of a sample by using the Naive Bayes Classifier
  include NaiveBayes

  validates :weight,    :presence => true, :numericality => true
  validates :height,    :presence => true, :numericality => true
  validates :foot_size, :presence => true, :numericality => true

  def test

    #males   = Individual.get_gender(Individual::MALE).map {|male| [ male.weight, male.height, male.foot_size ]}.transpose
    #females = Individual.get_gender(Individual::FEMALE).map {|female| [ female.weight, female.height, female.foot_size ]}.transpose

    attributes = [ :weight, :height, :foot_size ]

    data = prepare_data( attributes )

    puts '*'*80
    #print male
    #puts '&&&&'
    #print female
    #puts training_data
    puts data 
    puts '*'*80

    # Use module to generate real result
    #a = GenderDecider.new()
    #a.train( training_data )
    #a.get_posteriors( sample, Individual::MALEPROB, Individual::FEMALEPROB )
    #result = a.classify( Individual::MALE, Individual::FEMALE )

    # Testing response for AJAX
    'Yes, it is!'
    @test = blah()
    @test

  end

  private

  # Querys database for each gender according to the attributes and packages it up so 
  # that it can be sent to NaiveBayes classifer
  def prepare_data( attributes )

    training_data = Individual::GENDERS.inject({}) do |hash,gender| 
      data = []
      attributes.each do |attr|
          data << Individual.gender( gender ).map( &attr )
      end
      hash[ gender ] = data
      hash
    end

    return training_data 

    end
end
