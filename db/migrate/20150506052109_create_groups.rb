class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, unique: true
      t.string :events, array: true, default: []
      t.integer :admin
      t.string :members, array: true, default: []

      t.timestamps null: false
    end
  end
end
