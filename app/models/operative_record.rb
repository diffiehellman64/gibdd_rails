class OperativeRecord < ActiveRecord::Base

  has_paper_trail

  belongs_to :user
  belongs_to :district

  validates_uniqueness_of :target_day, scope: :district_id, on: :create

  validates :dead_count, 
            :personal_count,
            :personal_count,
            :reg_emergency_count,
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
            :arrested_day_count,
            :arrested_all_count,
            :parking_count,
            :article_264_1_count,
            :oop_count,
            :solved_crime_count,
            :stealing_autos,
            :theft_autos,
            :stealing_solved,
            :theft_solved,
            :stealing_solved_gibdd,
            :theft_solved_gibdd,
          numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  
#  validate :reg_em, :stel_auto, :theft_auto, :adm_check

  before_save :nil_to_0

  def reg_em
    self.reg_emergency_count = 0 if self.reg_emergency_count.nil?
    self.perished_count = 0 if self.perished_count.nil?
    self.dead_count = 0 if self.dead_count.nil?
    if self.reg_emergency_count > self.perished_count + self.dead_count
      errors.add(:reg_emergency_count, 'can not be greater than perished_count + dead_count')
    end
  end

  def stel_auto
    self.stealing_autos = 0 if self.stealing_autos.nil?
    self.stealing_solved = 0 if self.stealing_solved.nil?
    self.theft_solved_gibdd = 0 if self.theft_solved_gibdd.nil?
    if self.stealing_autos < self.stealing_solved
      errors.add(:stealing_autos, 'can not be less than stealing_solved')
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
    self.reg_emergency_count = 0 if self.reg_emergency_count.nil?
    self.dead_count = 0 if self.dead_count.nil?
    self.perished_count = 0 if self.perished_count.nil?
    self.adm_emergency_count = 0 if self.adm_emergency_count.nil?
    self.reg_emergency_child_count = 0 if self.reg_emergency_child_count.nil?
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
    self.arrested_day_count = 0 if self.arrested_day_count.nil?
    self.arrested_all_count = 0 if self.arrested_all_count.nil?
    self.parking_count = 0 if self.parking_count.nil?
    self.article_264_1_count = 0 if self.article_264_1_count.nil?
    self.oop_count = 0 if self.oop_count.nil?
    self.solved_crime_count = 0 if self.solved_crime_count.nil?
    self.stealing_autos = 0 if self.stealing_autos.nil?
    self.theft_autos = 0 if self.theft_autos.nil?
    self.stealing_solved = 0 if self.stealing_solved.nil?
    self.theft_solved = 0 if self.theft_solved.nil?
    self.stealing_solved_gibdd = 0 if self.stealing_solved_gibdd.nil?
    self.theft_solved_gibdd = 0 if self.theft_solved_gibdd.nil?
  end


  def get_cafap(conn)
    if self.district_id == 21
      self.source = 'ott'
      conn.exec("SELECT COUNT(LISHENTSY.TRIBUNAL_DATE) FROM LISHENTSY
                 WHERE TRUNC(LISHENTSY.TRIBUNAL_DATE) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','ddmmyyyy') AND LISHENTSY.DRUNKARD = 22") do |r|
        self.all_violations_count = r[0].to_i
      end
      conn.exec("SELECT COUNT(LISHENTSY.TRIBUNAL_DATE) FROM LISHENTSY
                 WHERE TRUNC(LISHENTSY.TRIBUNAL_DATE) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND LISHENTSY.DRUNKARD = 22 AND LISHENTSY.VARTICLE = '12.9'") do |r|
        self.speed_count = r[0].to_i
      end
      conn.exec("SELECT COUNT(LISHENTSY.TRIBUNAL_DATE) FROM LISHENTSY
                 WHERE TRUNC(LISHENTSY.TRIBUNAL_DATE) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND LISHENTSY.DRUNKARD = 22 AND LISHENTSY.VARTICLE = '12.15' AND LISHENTSY.VPART = '4'") do |r|
        self.opposite_count = r[0].to_i
      end
    end
  end

  def get_emergency_data(aius)
    dist = District.find(self.district_id)
    if dist.code >= 1 and dist.code <= 21
      self.source = 'aius'
      self.reg_emergency_count = 0
      self.perished_count = 0
      self.dead_count = 0
      self.adm_emergency_count = 0

      self.reg_emergency_child_count = 0
      self.dead_child_count = 0
      self.perished_child_count = 0

      self.reg_emergency_drunk_count = 0
      self.dead_drunk_count = 0
      self.perished_drunk_count = 0


# Административные ДТП

      aius.exec("SELECT count(em.em_id)
                 FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON(em.em_id = ep.em_id)
                 LEFT OUTER JOIN places pl ON (ep.place_id = pl.place_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND em.em_archive = 'F' AND em.em_state NOT IN('0', '2')
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.adm_emergency_count = r[0].to_i
      end

# Учетные ДТП

      aius.exec("SELECT count(em.em_id)
                 FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON(em.em_id = ep.em_id)
                 LEFT OUTER JOIN places pl ON (ep.place_id = pl.place_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND em.em_archive = 'F' AND em.em_state IN('0', '2')
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
         self.reg_emergency_count = r[0].to_i
      end

      aius.exec("SELECT COUNT(eper.em_place_person_id) 
                 FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON (em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND em.em_state IN('0', '2') 
                 AND em.em_archive = 'F'
                 AND eper.em_place_person_archive = 'F' 
                 AND dht.hv_type_supertype = 2
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.perished_count = r[0].to_i
      end 

      aius.exec("SELECT COUNT(eper.em_place_person_id) 
                 FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON (em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','ddmmyyyy')
                 AND em.em_state IN('0', '2') 
                 AND em.em_archive = 'F'
                 AND eper.em_place_person_archive = 'F' 
                 AND dht.hv_type_supertype = 3
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.dead_count = r[0].to_i
      end

# ДТП с детьми до 16 лет

      aius.exec("SELECT COUNT(em), district_code FROM
                  (SELECT DISTINCT em.em_id as em, GET_DISTRICT_CODE(ep.place_id) as district_code
                  FROM emergencies em
                  LEFT OUTER JOIN emergency_places ep ON(em.em_id = ep.em_id)
                  LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                  LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                  WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                  AND em.em_archive = 'F' 
                  AND em.em_state IN('0', '2')
                  AND em.em_moment < ADD_MONTHS(eper.person_birthday, 16 * 12)
                  AND eper.if_child = 1
                  AND eper.em_place_person_archive = 'F'
                  AND dht.hv_type_supertype IN (2, 3))
                  WHERE district_code = #{dist.code}
                  GROUP BY district_code") do |r|
        self.reg_emergency_child_count = r[0].to_i
      end

      aius.exec("SELECT COUNT(em.em_id), GET_DISTRICT_CODE(ep.place_id)
                 FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON(em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND em.em_archive = 'F' 
                 AND em.em_state IN('0', '2')
                 AND em.em_moment < ADD_MONTHS(eper.person_birthday, 16 * 12)
                 AND eper.if_child = 1
                 AND eper.em_place_person_archive = 'F'
                 AND dht.hv_type_supertype = 3
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.dead_child_count = r[0].to_i
      end
 
      aius.exec("SELECT COUNT(em.em_id), GET_DISTRICT_CODE(ep.place_id)
                 FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON(em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND em.em_archive = 'F'
                 AND em.em_state IN('0', '2')
                 AND em.em_moment < ADD_MONTHS(eper.person_birthday, 16 * 12)
                 AND eper.if_child = 1
                 AND eper.em_place_person_archive = 'F'
                 AND dht.hv_type_supertype = 2
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.perished_child_count = r[0].to_i
      end

# ДТП с пьяными
 
      aius.exec("SELECT COUNT(em) 
                 FROM
                 (SELECT DISTINCT em.em_id AS em, GET_DISTRICT_CODE(ep.place_id) AS district_code FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON (em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN emtransperson_derangements etpd ON (eper.em_place_person_id = etpd.em_place_person_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','dd.mm.yyyy')
                 AND em.em_state IN ('0', '2')
                 AND em.em_archive = 'F'
                 AND (SELECT COUNT(*) FROM emtransperson_derangements etpd2
                 WHERE etpd2.derang_id NOT IN (63, 100) AND etpd2.main_attendant = 1 AND etpd2.em_place_person_id = eper.em_place_person_id) > 0
                 AND etpd.derang_id IN (3, 44, 135, 136, 137, 138)
                 AND eper.part_type_id = 1
                 AND eper.em_place_person_archive = 'F')
                 WHERE district_code = #{dist.code}
                 GROUP BY district_code") do |r|
        self.reg_emergency_drunk_count = r[0].to_i
      end

# ДТП с пешеходами
# EMPTY YET....

# Наезды на пешеходов на зебре
      aius.exec("SELECT COUNT(*)
                  FROM (SELECT DISTINCT em.em_id, GET_DISTRICT_CODE(ep.place_id) as district_code FROM emergencies em
                  LEFT OUTER JOIN emergency_place_summary eps ON (em.em_id = eps.em_s_id AND eps.place_id = 512)
                  LEFT OUTER JOIN emergency_places ep ON (em.em_id = ep.em_id)
                  LEFT OUTER JOIN emtransport_rdconstrs etr ON (ep.em_place_id = etr.em_place_id)
                  WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','ddmmyyyy')
                  AND em.em_state IN ('0', '2')
                  AND em.em_archive = 'F'
                  AND etr.rd_constr_id IN (5, 6, 47, 48)
                  AND em.em_type_id = 292) 
                  WHERE district_code = #{dist.code}
                  GROUP BY district_code") do |r|
        self.reg_emergency_footer_on_zebra_count = r[0].to_i
      end

      aius.exec("SELECT COUNT(eper.em_place_person_id)
                 FROM (SELECT DISTINCT em.em_id FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON (em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN emtransport_rdconstrs etr ON (ep.em_place_id = etr.em_place_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','ddmmyyyy')
                 AND em.em_state IN ('0', '2')
                 AND em.em_archive = 'F'
                 AND etr.rd_constr_id IN (5, 6, 47, 48)
                 AND em.em_type_id = 292
                 AND eper.em_place_person_archive = 'F') em2
                 LEFT OUTER JOIN emergency_places ep ON (em2.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                 WHERE eper.em_place_person_archive = 'F'
                 AND dht.hv_type_supertype = 3
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.dead_footer_on_zebra_count = r[0].to_i
      end

      aius.exec("SELECT COUNT(eper.em_place_person_id)
                 FROM (SELECT DISTINCT em.em_id FROM emergencies em
                 LEFT OUTER JOIN emergency_places ep ON (em.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN emtransport_rdconstrs etr ON (ep.em_place_id = etr.em_place_id)
                 WHERE TRUNC(em.em_moment) = TO_DATE('#{self.target_day.strftime('%d%m%Y')}','ddmmyyyy')
                 AND em.em_state IN ('0', '2')
                 AND em.em_archive = 'F'
                 AND etr.rd_constr_id IN (5, 6, 47, 48)
                 AND em.em_type_id = 292
                 AND eper.em_place_person_archive = 'F') em2
                 LEFT OUTER JOIN emergency_places ep ON (em2.em_id = ep.em_id)
                 LEFT OUTER JOIN emtransport_persons eper ON (ep.em_place_id = eper.em_place_id)
                 LEFT OUTER JOIN dtp_heaviness_types dht ON (dht.hv_type_id = eper.hv_type_id)
                 WHERE eper.em_place_person_archive = 'F'
                 AND dht.hv_type_supertype = 2
                 AND GET_DISTRICT_CODE(ep.place_id) = #{dist.code}
                 GROUP BY GET_DISTRICT_CODE(ep.place_id)") do |r|
        self.perished_footer_on_zebra_count = r[0].to_i 
      end     
    end
  end
end
