class CreateDistricts < ActiveRecord::Migration
  def change
    create_table :districts do |t|
      
      t.integer    :code,       null: false
      t.string     :name,       null: false
      t.string     :short_name, null: false
      t.string     :alias_name

      t.timestamps null: false
    end
 
    add_index :districts, :code, unique: true 
 
  end
end
