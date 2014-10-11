class CreateApps < ActiveRecord::Migration
  def change
    create_table :apps do |t|
      t.string :name, unique: true, index: true
      t.string :description
      t.timestamps
    end
  end
end
