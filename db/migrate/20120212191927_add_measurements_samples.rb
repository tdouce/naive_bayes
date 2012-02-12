class AddMeasurementsSamples < ActiveRecord::Migration
  def change
    add_column :samples, :height_in, :integer
    add_column :samples, :height_ft, :integer
  end

end
