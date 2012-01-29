class Posterior < ActiveRecord::Base

  validates :male_posterior, :presence => true, :numericality => true
  validates :female_posterior, :presence => true, :numericality => true

  def self.set_posterior( male_posterior_result, female_posterior_result, gender_result )
    probs = Posterior.new()
    probs.male_posterior = male_posterior_result
    probs.female_posterior = female_posterior_result
    probs.gender = gender_result 
    probs.save
  end

end
