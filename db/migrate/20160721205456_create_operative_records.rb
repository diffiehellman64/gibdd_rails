class CreateOperativeRecords < ActiveRecord::Migration
  def change
    create_table :operative_records do |t|
      t.references :user, foreign_key: true,   null: false
      t.date :target_day,                      null: false

      t.integer :personal_count,               null: false

      t.integer :registry_emergency_count,     null: false
      t.integer :dead_count,                   null: false
      t.integer :perished_count,               null: false
      t.integer :adm_emergency_count,          null: false

      t.integer :all_violations_count,         null: false
      t.integer :drunk_count,                  null: false
      t.integer :opposite_count,               null: false
      t.integer :not_having_count,             null: false
      t.integer :speed_count,                  null: false
      t.integer :failure_to_footer_count,      null: false
      t.integer :belts_count,                  null: false
      t.integer :passengers_count,             null: false
      t.integer :tinting_count,                null: false
      t.integer :footer_count,                 null: false
      t.integer :arested_day_count,            null: false
      t.integer :arested_all_count,            null: false
      t.integer :parking_count,                null: false

      t.integer :article_264_1_count,          null: false
      t.integer :oop_count,                    null: false
      t.integer :solved_crime_count,           null: false

      t.integer :stealing_autos,               null: false
      t.integer :theft_autos,                  null: false
      t.integer :stealing_sloved,              null: false
      t.integer :theft_sloved,                 null: false
      t.integer :stealing_sloved_gibdd,        null: false
      t.integer :theft_sloved_gibdd,           null: false

      t.integer :district_code,                null: false

      t.timestamps null: false
    end
  end
end
