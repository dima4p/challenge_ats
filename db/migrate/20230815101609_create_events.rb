class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :type, null: false
      t.string :object_type, null: false
      t.integer :object_id, null: false
      t.datetime :date
      t.text :content

      t.timestamps
    end
  end
end
