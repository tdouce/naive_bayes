class CreatePosteriors < ActiveRecord::Migration
  def change
    create_table :posteriors do |t|
      t.text :stats

      t.timestamps
    end
  end
end
