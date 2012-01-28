class Sample < ActiveRecord::Base

  # Determine gender of a sample by using the Naive Bayes Classifier
  #include NaiveBayesClassifier 

  validates :weight,    :presence => true, :numericality => true
  validates :height,    :presence => true, :numericality => true
  validates :foot_size, :presence => true, :numericality => true

  FORMATTRIBUTES = [ :weight, :height, :foot_size ]

  def prepare_sample
    sample_result = FORMATTRIBUTES.inject([]) do |result,attr|
      result << self.send(attr)
      result
    end
  end

  def run_sample( sample_data )

    #males   = Individual.get_gender(Individual::MALE).map {|male| [ male.weight, male.height, male.foot_size ]}.transpose
    #females = Individual.get_gender(Individual::FEMALE).map {|female| [ female.weight, female.height, female.foot_size ]}.transpose
    #
    #attributes = [ :weight, :height, :foot_size ]

    train( prepare_data( FORMATTRIBUTES ) )
    get_posteriors( sample_data, Individual::MALEPROB, Individual::FEMALEPROB )
    classify( Individual::MALE, Individual::FEMALE )
  end

  # Dynamically get attributes from current sample
  #def self.prepare_sample(sample)
  #  puts '*'*80
  #  puts 'testing bitches'

  #  #sample = []
  #  #attributes.each do |attr|
  #  # sample << self.map( &attr )
  #  #end

  #  #puts sample 
  #  puts '*'*80
  #end

  private

    # Querys database for each gender according to the attributes and packages it up so 
    # that it can be sent to NaiveBayes classifer
    def prepare_data( attributes )

      training_data = Individual::GENDERS.inject({}) do |hash,gender| 
        #data = []
        #attributes.each do |attr|
        data = attributes.inject([]) do |result, attr|
            result << Individual.gender( gender ).map( &attr )
            result
        end
        hash[ gender ] = data
        hash
      end

      return training_data 
      end

      # Generates means and variances. Accepts nested arrays of data. 
      # Returns an array of the means and an array of the variances
      def batch_train( data )
          means = []
          variances = []

          data.each do |d|
              d.map! {|num| Float( num ) }
              mean = d.mean 
              means << mean 
              variances << d.variance( mean ) 
          end
          
          return means, variances
      end

      ##Train data, get posterior for male and female, and compare results to determine gender 
      def train( training_data )

          # Get arrays containing means and variances
          @male_means, @male_variances = batch_train( training_data[ Individual::MALE ] )

          ## Get arrays containing means and variances
          @female_means, @female_variances = batch_train( training_data[ Individual::FEMALE ] )
      end

      # Generates posterior
      def get_posterior_for_gender( gender_probability, variances, means, sample )

          # Make and array for all probabilities
          probs = 1.upto( sample.size ).each_with_index.inject([]) do |probs, (attr, index)|
              probs <<  probability( variances[ index ], means[ index ], sample[ index ] )
              probs
          end

          # Add gender probability
          probs << gender_probability
          
          puts 'probs: '
          puts probs

          # Multiply all elements in array together
          probs.inject(){|product, element| product * element}
      end
      
      # Generate posterior for male and female
      def get_posteriors( sample, male_probability, female_probability )
          
          # Get posterior for male classification
          @male_posterior_numerator = get_posterior_for_gender( male_probability, @male_variances, @male_means, sample )

          # Get posterior for female classification
          @female_posterior_numerator = get_posterior_for_gender( female_probability, @female_variances, @female_means, sample )
      end

      # Generates probability for each combination (i.e. p(height|male), etc )
      def probability( variance, mean, measurement )
          male_numerator = ( 1 /( Math.sqrt( 2 * Math::PI * variance ) ))
          male_exponent = ( (-( measurement - mean)**2 ) / ( 2 * variance) )
          probability = male_numerator * Math.exp( male_exponent ) 
      end

      # Determine if male and female by comparing posteriors
      def classify( male_text, female_text )
          @male_posterior_numerator > @female_posterior_numerator ? male_text : female_text
      end


end
