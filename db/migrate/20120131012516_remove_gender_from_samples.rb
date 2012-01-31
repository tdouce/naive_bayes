class RemoveGenderFromSamples < ActiveRecord::Migration
  def up
    remove_column :samples, :gender
  end

  def down
    add_column :samples, :gender, :float
  end
end
