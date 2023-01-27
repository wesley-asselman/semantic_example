class CreateThings < ActiveRecord::Migration[6.1]
  def change
    create_table :things do |t|
      t.string :name
      t.json :properties
      t.json :instances
      t.timestamps
    end
  end
end
