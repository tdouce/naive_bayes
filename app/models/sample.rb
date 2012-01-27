class Sample < ActiveRecord::Base

  validates :weight,    :presence => true, :numericality => true
  validates :height,    :presence => true, :numericality => true
  validates :foot_size, :presence => true, :numericality => true

  # Remove
  def test
    'Yes, it is!'
  end
end
