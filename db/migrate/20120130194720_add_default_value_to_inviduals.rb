class AddDefaultValueToInviduals < ActiveRecord::Migration
  def change
    change_column :individuals, :trained, :boolean, :default=> 'false'
  end
end
