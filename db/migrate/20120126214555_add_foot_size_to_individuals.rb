class AddFootSizeToIndividuals < ActiveRecord::Migration
  def change
    add_column :individuals, :foot_size, :float
  end
end
