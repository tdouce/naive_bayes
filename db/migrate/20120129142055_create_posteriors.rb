class CreatePosteriors < ActiveRecord::Migration
  def change
    create_table :posteriors do |t|
      t.float :male_posterior
      t.float :female_posterior

      t.timestamps
    end
  end
end
