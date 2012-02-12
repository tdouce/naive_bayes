
class Sample < ActiveRecord::Base

  include NaiveBayesClassifier
  
  before_save :height_to_decimal_inches

  validates :weight,    :presence => true, :numericality => { :greater_than => 50, :less_than_or_equal_to => 400 }
  validates :height_ft, :numericality => { :only_integer => true, :less_than_or_equal_to => 7 }
  validates :height_in, :numericality => { :less_than_or_equal_to => 11 }, :allow_blank => true
  validates :foot_size, :presence => true, :numericality => { :greater_than => 4, :less_than_or_equal_to => 17 }

  # Attributes that we are included in naive bayes classier
  # If you want to add another attribute to be included in the
  # NaiveBayesClassier, then add it here.
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

    # Run sample only if there is training data
    if Individual.all.count != 0 

      untrained_individuals = Individual.untrained

      # Run sample only if there are untrained individuals
      if untrained_individuals.count > 0

        # Query database, get male and female data and package in hash
        prepped_data = prepare_data( FORMATTRIBUTES )

        # Generate the means and variances per gender
        means_variances = train( Individual::GENDERS, prepped_data )

        # Generate the posterior numerators per gender
        male_posterior, female_posterior = posteriors( sample_data, 
                                                       Individual::MALEPROB, 
                                                       Individual::FEMALEPROB, 
                                                       means_variances, 
                                                       Individual::MALE, 
                                                       Individual::FEMALE
                                                     )

        # Determine classification
        result = classify( Individual::MALE, Individual::FEMALE, male_posterior, female_posterior )

        # Set trained status to true for every individual that previously had a false trained status
        untrained_individuals.update_all( :trained => true )

        # Store the means and variances for the trained data in the posteriors table so if another request is make and 
        # there have been no additions or updates to the training data, then we can query the means and variances from this request
        Posterior.posterior_for_next_request( means_variances )

        result

      # If all individuals trained status is true, then we do not need to
      # re-train the data to get the means and variances, we can query the
      # the posteriors table and get the previously calculated means and variances
      else

        previously_trained = Posterior.last
        means_variances = previously_trained.stats 

        # Generate the posterior numerators per gender
        male_posterior, female_posterior = posteriors( sample_data, 
                                                       Individual::MALEPROB, 
                                                       Individual::FEMALEPROB, 
                                                       means_variances, 
                                                       Individual::MALE, 
                                                       Individual::FEMALE
                                                     )


        # Determine classification
        result = classify( Individual::MALE, Individual::FEMALE, male_posterior, female_posterior )
      end

    # If there is no training data, then tell user so and do not run a calculation
    else
      'There is no training data'
    end
  end

  private
    
    # Querys database for each gender according to FORMATTRIBUTES and packages it up in a hash so 
    # that it can be sent to NaiveBayesClassifer
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
end
