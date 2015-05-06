class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :events, array: true, default: []
      t.integer :admin
      t.integer :members, array: true, default: []

      t.timestamps null: false
    end
  end
end
