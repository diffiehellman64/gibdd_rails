class OperativeRecord < ActiveRecord::Base

  belongs_to :user
  belongs_to :district

  validates_uniqueness_of :target_day, scope: :district_id

  validates :dead_count, 
            :personal_count,
            :personal_count,
            :registry_emergency_count,
            :adm_emergency_count,
            :all_violations_count,
            :drunk_count,
            :opposite_count,
            :not_having_count,
            :speed_count,
            :failure_to_footer_count,
            :belts_count,
            :passengers_count,
            :tinting_count,
            :footer_count,
            :arested_day_count,
            :arested_all_count,
            :parking_count,
            :article_264_1_count,
            :oop_count,
            :solved_crime_count,
            :stealing_autos,
            :theft_autos,
            :stealing_sloved,
            :theft_sloved,
            :stealing_sloved_gibdd,
            :theft_sloved_gibdd,
          numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  
  validate :reg_em, :stel_auto, :theft_auto, :adm_check

  before_save :nil_to_0

  def reg_em
    self.registry_emergency_count = 0 if self.registry_emergency_count.nil?
    self.perished_count = 0 if self.perished_count.nil?
    self.dead_count = 0 if self.dead_count.nil?
    if self.registry_emergency_count > self.perished_count + self.dead_count
      errors.add(:registry_emergency_count, 'can not be greater than perished_count + dead_count')
    end
  end

  def stel_auto
    self.stealing_autos = 0 if self.stealing_autos.nil?
    self.stealing_sloved = 0 if self.stealing_sloved.nil?
    self.theft_sloved_gibdd = 0 if self.theft_sloved_gibdd.nil?
    if self.stealing_autos < self.stealing_sloved
      errors.add(:stealing_autos, 'can not be less than stealing_sloved')
    end
  end

  def theft_auto
  end  

  def adm_check
    self.all_violations_count = 0 if self.all_violations_count.nil?
    self.drunk_count = 0 if self.drunk_count.nil?
    self.opposite_count = 0 if self.opposite_count.nil?
    self.not_having_count = 0 if self.not_having_count.nil?
    self.speed_count = 0 if self.speed_count.nil?
    self.failure_to_footer_count = 0 if self.failure_to_footer_count.nil?
    self.belts_count = 0 if self.belts_count.nil?
    self.passengers_count = 0 if self.passengers_count.nil?
    self.tinting_count = 0 if self.tinting_count.nil?
    self.footer_count = 0 if self.footer_count.nil?
    if self.all_violations_count < self.drunk_count + self.opposite_count + self.not_having_count + 
                                   self.speed_count + self.failure_to_footer_count + self.belts_count + 
                                   self.passengers_count + self.tinting_count + self.footer_count
      errors.add(:all_violations_count, 'can not be less than summ of violations')
    end
  end

  def nil_to_0
    self.personal_count = 0 if self.personal_count.nil?
    self.registry_emergency_count = 0 if self.registry_emergency_count.nil?
    self.dead_count = 0 if self.dead_count.nil?
    self.perished_count = 0 if self.perished_count.nil?
    self.adm_emergency_count = 0 if self.adm_emergency_count.nil?
    self.all_violations_count = 0 if self.all_violations_count.nil?
    self.drunk_count = 0 if self.drunk_count.nil?
    self.opposite_count = 0 if self.opposite_count.nil?
    self.not_having_count = 0 if self.not_having_count.nil?
    self.speed_count = 0 if self.speed_count.nil?
    self.failure_to_footer_count = 0 if self.failure_to_footer_count.nil?
    self.belts_count = 0 if self.belts_count.nil?
    self.passengers_count = 0 if self.passengers_count.nil?
    self.tinting_count = 0 if self.tinting_count.nil?
    self.footer_count = 0 if self.footer_count.nil?
    self.arested_day_count = 0 if self.arested_day_count.nil?
    self.arested_all_count = 0 if self.arested_all_count.nil?
    self.parking_count = 0 if self.parking_count.nil?
    self.article_264_1_count = 0 if self.article_264_1_count.nil?
    self.oop_count = 0 if self.oop_count.nil?
    self.solved_crime_count = 0 if self.solved_crime_count.nil?
    self.stealing_autos = 0 if self.stealing_autos.nil?
    self.theft_autos = 0 if self.theft_autos.nil?
    self.stealing_sloved = 0 if self.stealing_sloved.nil?
    self.theft_sloved = 0 if self.theft_sloved.nil?
    self.stealing_sloved_gibdd = 0 if self.stealing_sloved_gibdd.nil?
    self.theft_sloved_gibdd = 0 if self.theft_sloved_gibdd.nil?
  end

end
