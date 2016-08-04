class CreateOperativeRecords < ActiveRecord::Migration
  def change
    create_table :operative_records do |t|
      t.references :user,        foreign_key: true,   null: false, default: 0
      t.references :district, null: false
      t.date       :target_day, null: false

      t.integer :personal_count

      t.integer :registry_emergency_count
      t.integer :dead_count
      t.integer :perished_count
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
      t.integer :arested_day_count
      t.integer :arested_all_count
      t.integer :parking_count

      t.integer :article_264_1_count
      t.integer :oop_count
      t.integer :solved_crime_count

      t.integer :stealing_autos
      t.integer :theft_autos
      t.integer :stealing_sloved
      t.integer :theft_sloved
      t.integer :stealing_sloved_gibdd
      t.integer :theft_sloved_gibdd

      t.timestamps null: false
    end
  end
end
