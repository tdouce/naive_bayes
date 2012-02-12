class AddMeasurementsIndividuals < ActiveRecord::Migration
  def change
    add_column :individuals, :height_in, :integer
    add_column :individuals, :height_ft, :integer
  end

end
