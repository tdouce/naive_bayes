
#require 'naive_bayes_classifier'

class Sample < ActiveRecord::Base

  include NaiveBayesClassifier

  validates :weight,    :presence => true, :numericality => true
  validates :height,    :presence => true, :numericality => true
  validates :foot_size, :presence => true, :numericality => true

  # Attributes that we are included in naive bayes classier
  FORMATTRIBUTES = [ :weight, :height, :foot_size ]

  # Packages up data for a sumbited sample
  def prepare_sample
    sample_result = FORMATTRIBUTES.inject([]) { |result,attr| result << self.send( attr ) }
  end


  # If there is no training data then do not run any calculation and instead return 
  # text notifing user. If there is data and at least one individual has :trained => false, 
  # then train the data and calcuate the posteriors for each classification( male and female). 
  # Then set all indivuduals trained status to true and save the means and
  # variances in the posteriors table.  If there is training data and there have
  # been no additions or edits to individuals table ( trained status is false by default
  # for new and is set to false if an individual was edited ), then retreive
  # means and variances from previous request.
  def run_sample( sample_data )

    #a = testing

    #debugger
    

    # Run sample only if there is training data
    if Individual.all.count != 0 

      untrained_individuals = Individual.untrained

      # Run sample only if there are untrained individuals
      if untrained_individuals.count > 0

        # Query database, get male and female data and package in hash
        prepped_data = prepare_data( FORMATTRIBUTES )

        # Generate the means and variances per gender
        means_variances = train( prepped_data )

        # Generate the posterior numerators per gender
        male_posterior_result, female_posterior_result = posteriors( sample_data, Individual::MALEPROB, Individual::FEMALEPROB, means_variances )

        # Determine classification
        result = classify( Individual::MALE, Individual::FEMALE, male_posterior_result, female_posterior_result )

        # Set trained status to true for every individual that previously had a trained status as false
        untrained_individuals.update_all( :trained => true )

        # Store the means and variances for the trained data in the posteriors table so if another request is make and 
        # there have been no additions or updates to the training data, then we can query the means and variances from
        # this request
        Posterior.posterior_for_next_request( means_variances )

        result

      # If all individuals trained status is true, then we do not need to
      # re-train the data to get the means and variances, we can query the
      # the Posterior table and get the previously calculated means and variances
      else

        previously_trained = Posterior.last
        means_variances = previously_trained.stats 

        # Generate posterior numerators per gender
        male_posterior_result, female_posterior_result = posteriors( sample_data, Individual::MALEPROB, Individual::FEMALEPROB, means_variances )

        # Determine classification
        result = classify( Individual::MALE, Individual::FEMALE, male_posterior_result, female_posterior_result )

      end

    # If there is no training data, then tell user so and do not run a calculation
    else
      'There is no training data'
    end
  end

  private

      # Querys database for each gender according to the attributes and packages it up in a hash so 
      # that it can be sent to NaiveBayes classifer
      def prepare_data( attributes )

      training_data = Individual::GENDERS.inject({}) do |hash,gender| 

        data = attributes.inject([]) do |result, attr|
            result << Individual.gender( gender ).map( &attr )
            result
        end

        hash[ gender ] = data
        hash
      end

      return training_data 
      end

      # Generates means and variances
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

      # Train data, get posterior for male and female, and compare results to determine gender 
      def train( training_data )

          data = Individual::GENDERS.inject({}) do |hash,gender|
            means, variances = batch_train( training_data[ gender ] )
            hash[ gender ] = [ means, variances ]
            hash
          end

          return data 
      end

      # Generate posterior
      def posterior_for_gender( gender_probability, variances, means, sample )

          # Make and array for all probabilities
          probs = 1.upto( sample.size ).each_with_index.inject([]) do |probs, (attr, index)|
              probs <<  probability( variances[ index ], means[ index ], sample[ index ] )
              probs
          end

          # Add gender probability
          probs << gender_probability
          
          puts 'probs: '
          puts probs

          # Generate product of array 
          probs.inject(){|product, element| product * element}
      end
      
      # Generate posterior per gender
      def posteriors( sample, male_probability, female_probability, means_variances )
          
          male_posterior_numerator   = posterior_for_gender( male_probability, means_variances[Individual::MALE][1], means_variances[Individual::MALE][0], sample )
          female_posterior_numerator = posterior_for_gender( female_probability, means_variances[Individual::FEMALE][1], means_variances[Individual::FEMALE][0], sample )

          return male_posterior_numerator, female_posterior_numerator
      end

      # Generates probability for each combination (i.e. p(height|male), etc )
      def probability( variance, mean, measurement )
          male_numerator = ( 1 /( Math.sqrt( 2 * Math::PI * variance ) ))
          male_exponent = ( (-( measurement - mean)**2 ) / ( 2 * variance) )
          probability = male_numerator * Math.exp( male_exponent ) 
      end

      # Determine gender by comparing posteriors
      def classify( male_text, female_text, male_posterior_numerator, female_posterior_numerator )
          male_posterior_numerator > female_posterior_numerator ? male_text : female_text
      end
end
