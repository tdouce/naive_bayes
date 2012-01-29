
#require naive_bayes_classifier
#include NaiveBayesClassifier 
#require NaiveBayesClassifier 

class Sample < ActiveRecord::Base

  # Determine gender of a sample by using the Naive Bayes Classifier

  validates :weight,    :presence => true, :numericality => true
  validates :height,    :presence => true, :numericality => true
  validates :foot_size, :presence => true, :numericality => true

  # Attributes that we are included in naive bayes classier
  FORMATTRIBUTES = [ :weight, :height, :foot_size ]

  # Packages up data for a sumbited sample
  def prepare_sample
    sample_result = FORMATTRIBUTES.inject([]) { |result,attr| result << self.send( attr ) }
  end

  def set_trained_status
    self.update_attributes( :trained => false )
  end

  # Run the sample from the sample#new.html.erb. If there is no training data
  # then do not run and instead return text notifing user. If there is data and
  # at least one individual has :trained => false, then calculate the posteriors
  # for each class( male and female). Save posterior to database and set all
  # invidividuals :trained => true. If the individuals size is greater than one
  # and all individuals :trained => true, then we know that no individuals have
  # been added to training data so we can use the last posterior that was saved
  # in the database.  This saves us from having to calculate the posterior each
  # time a request is made, thus calculating the posterior only when neccessary. 
  def run_sample( sample_data )

    # Run sample only if there is training data
    if Individual.all.size > 1 

      not_trained_individuals = Individual.trained?

      # If there are individuals with :trained => false
      if not_trained_individuals.size > 0

        prepped_data = prepare_data( FORMATTRIBUTES )
        means_variances = train( prepped_data )
        male_posterior_result, female_posterior_result = get_posteriors( sample_data, Individual::MALEPROB, Individual::FEMALEPROB, means_variances )
        result = classify( Individual::MALE, Individual::FEMALE, male_posterior_result, female_posterior_result )

        # Sets all individuals with :trained => false to true
        # Does this belong in controller?
        Individual.to_trained( not_trained_individuals )

        # Saves posterior results to database
        # Does this belong in controller?
        # Posterior.set_posterior( means_variances )
        
        result

      # All individuals trained status is true, we can get the gender from the
      # last Posterior that was saved
      else
        #probability = Posterior.last
        #result = probability.gender
        'get from posterior table'
      end

    # If there is not training data, then tell user so and do not run
    # a calculation
    else
      'There is no training data'
    end

  end

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

      #Train data, get posterior for male and female, and compare results to determine gender 
      def train( training_data )

          # Get arrays containing means and variances
          male_means, male_variances = batch_train( training_data[ Individual::MALE ] )

          ## Get arrays containing means and variances
          female_means, female_variances = batch_train( training_data[ Individual::FEMALE ] )

          data = {}
          data['male'] = [ male_means, male_variances ]
          data['female'] = [ female_means, female_variances ]

          return data 
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
      def get_posteriors( sample, male_probability, female_probability, means_variances )
          
          puts '*'*80
          puts means_variances
          puts '*'*80
            
          # Get posterior for male classification
          male_posterior_numerator = get_posterior_for_gender( male_probability, means_variances['male'][1], means_variances['male'][0], sample )

          # Get posterior for female classification
          female_posterior_numerator = get_posterior_for_gender( female_probability, means_variances['female'][1], means_variances['female'][0], sample )

          return male_posterior_numerator, female_posterior_numerator
      end

      # Generates probability for each combination (i.e. p(height|male), etc )
      def probability( variance, mean, measurement )
          male_numerator = ( 1 /( Math.sqrt( 2 * Math::PI * variance ) ))
          male_exponent = ( (-( measurement - mean)**2 ) / ( 2 * variance) )
          probability = male_numerator * Math.exp( male_exponent ) 
      end

      # Determine if male and female by comparing posteriors
      def classify( male_text, female_text, male_posterior_numerator, female_posterior_numerator )
          male_posterior_numerator > female_posterior_numerator ? male_text : female_text
      end


end
