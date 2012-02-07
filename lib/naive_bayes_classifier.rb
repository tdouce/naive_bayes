
# Based on the Naive Bayes Classier equation found at http://en.wikipedia.org/wiki/Naive_Bayes_classifier
module NaiveBayesClassifier 

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
  def train( genders, training_data )

      data = genders.inject({}) do |hash,gender|
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

