class CreateOperativeRecords < ActiveRecord::Migration
  def change
    create_table :operative_records do |t|
      t.references :user, foreign_key: true
      t.date :target_day

      t.integer :registry_emergency_count,     null: false, default: 0
      t.integer :dead_count,                   null: false, default: 0
      t.integer :perished_count,               null: false, default: 0
      t.integer :adm_emergency_count,          null: false, default: 0

      t.integer :all_violations_count,         null: false, default: 0
      t.integer :drunk_count,                  null: false, default: 0
      t.integer :opposite_count,               null: false, default: 0
      t.integer :not_having_count,             null: false, default: 0
      t.integer :speed_count,                  null: false, default: 0
      t.integer :failure_to_footer_count,      null: false, default: 0
      t.integer :belts_count,                  null: false, default: 0
      t.integer :passengers_count,             null: false, default: 0
      t.integer :tinting_count,                null: false, default: 0
      t.integer :footer_count,                 null: false, default: 0
      t.integer :arested_day_count,            null: false, default: 0
      t.integer :arested_all_count,            null: false, default: 0
      t.integer :parking_count,                null: false, default: 0

      t.integer :article_264_1_count,          null: false, default: 0
      t.integer :oop_count,                    null: false, default: 0
      t.integer :solved_crime_count,           null: false, default: 0

      t.integer :district_code,                null: false, default: 0

      t.timestamps null: false
    end
  end
end
