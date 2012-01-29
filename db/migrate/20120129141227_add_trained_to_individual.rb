class AddTrainedToIndividual < ActiveRecord::Migration
  def change
    add_column :individuals, :trained, :boolean
  end
end
