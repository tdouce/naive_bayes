
module NaiveBayesClassifier 

  def testing
    'from module'
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

