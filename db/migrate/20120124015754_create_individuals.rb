class CreateIndividuals < ActiveRecord::Migration
  def change
    create_table :individuals do |t|
      t.string :gender
      t.float :weight
      t.float :height

      t.timestamps
    end
  end
end
