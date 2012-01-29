class AddGenderToPosterior < ActiveRecord::Migration
  def change
    add_column :posteriors, :gender, :string
  end
end
