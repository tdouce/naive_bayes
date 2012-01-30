class Posterior < ActiveRecord::Base
  serialize :stats

  def self.posterior_for_next_request( means_variances )
    if Posterior.count == 0
      Posterior.create( :stats => means_variances )
    else
      Posterior.last.destroy
      Posterior.create( :stats => means_variances )
    end
  end
end
