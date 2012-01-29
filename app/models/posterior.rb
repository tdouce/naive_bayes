class Posterior < ActiveRecord::Base
  attr_accessor :poor_man_memcache
  #attr_accessible :poor_man_memcache
  
  #serialize :stats

  #def self.set_posterior( means_variances )
  #  test = Posterior.create( :stats => means_variances )
  #end
  @@poor_man_memcache = nil 

  def set_poor_man_memcache( hash )
    @poor_man_memcache = hash
  end

  def get_poor_man_memcache
    @@poor_man_memcache
  end

  
  #def initialize
  #  @poor_man_memcache = nil 
  #end

end
