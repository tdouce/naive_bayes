class Posterior < ActiveRecord::Base
  serialize :stats

  def self.set_posterior( means_variances )
    test = Posterior.create( :stats => means_variances )
  end
end
