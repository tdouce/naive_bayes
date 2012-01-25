class CreateSamples < ActiveRecord::Migration
  def change
    create_table :samples do |t|
      t.string :gender
      t.float :weight
      t.float :height

      t.timestamps
    end
  end
end
