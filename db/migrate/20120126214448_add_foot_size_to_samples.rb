class AddFootSizeToSamples < ActiveRecord::Migration
  def change
    add_column :samples, :foot_size, :float
  end
end
