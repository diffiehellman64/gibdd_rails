class CreateOperativeRecords < ActiveRecord::Migration
  def change
    create_table :operative_records do |t|
      t.references :user,        foreign_key: true,   null: false, default: 0
      t.references :district, null: false
      t.date       :target_day, null: false

      t.integer :personal_count

      t.integer :reg_emergency_count
      t.integer :dead_count
      t.integer :perished_count

      t.integer :reg_emergency_child_count
      t.integer :dead_child_count
      t.integer :perished_child_count

      t.integer :reg_emergency_drunk_count
      t.integer :dead_drunk_count
      t.integer :perished_drunk_count

      t.integer :reg_emergency_footer_count
      t.integer :dead_footer_count
      t.integer :perished_footer_count

      t.integer :reg_emergency_footer_on_zebra_count
      t.integer :dead_footer_on_zebra_count
      t.integer :perished_footer_on_zebra_count

      t.integer :adm_emergency_count

      t.integer :all_violations_count
      t.integer :drunk_count
      t.integer :opposite_count
      t.integer :not_having_count
      t.integer :speed_count
      t.integer :failure_to_footer_count
      t.integer :belts_count
      t.integer :passengers_count
      t.integer :tinting_count
      t.integer :footer_count
      t.integer :arrested_day_count
      t.integer :arrested_all_count
      t.integer :parking_count

      t.integer :article_264_1_count
      t.integer :oop_count
      t.integer :not_trafic_oop_count
      t.integer :solved_crime_count

      t.integer :stealing_autos
      t.integer :theft_autos
      t.integer :stealing_solved
      t.integer :theft_solved
      t.integer :stealing_solved_gibdd
      t.integer :theft_solved_gibdd

      t.string  :source
 
      t.timestamps null: false
    end
   
    add_index :operative_records, :target_day
    add_index :operative_records, :user_id
    add_index :operative_records, :district_id
   
  end
end
