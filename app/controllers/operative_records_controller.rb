class OperativeRecordsController < ApplicationController

  load_and_authorize_resource

  respond_to :html, :js, :inline
#  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  def index
    if current_user.district_id.nil? || current_user.district_id == 21
      district_id = 1
    else
      district_id = current_user.district_id
    end
    if district_id = 0
      district_id = 1
    end
    @district = District.find(district_id)
    @operative_records = OperativeRecord.where(district_id: district_id).order('target_day desc')
  end

  def new
    @districts = District.all.order(:id)
    # @saved_operative_records = OperativeRecord.where(district_id: current_user.district_id).order('target_day desc').limit(31).reverse
    @target_day = DateTime.strptime(params[:target_day], '%d%m%Y')
    @operative_record = OperativeRecord.new
    @operative_record.district_id = params[:district_id]
    @operative_record.target_day = @target_day
  end  

  def edit
    @districts = District.all.order(:id)
  end

  def create
    @operative_record = OperativeRecord.new(operative_record_params)
    @operative_record.user_id = current_user.id
    @operative_record.source = 'human'
    if current_user.district_id.between?(1, 20)
      @operative_record.district_id = current_user.district_id
    end
    if @operative_record.save
      pjax_redirect_to(all_operative_records_path(@operative_record.target_day.strftime("%d%m%Y")), '[pjax-container]',
                       'success^Оперативные данные успешно переданы')
    else
      @operative_record.valid?
      @errors = @operative_record.errors
      render json: @errors
    end
  end

  def update
    @operative_record = OperativeRecord.find(params[:id])
    @operative_record.source = 'human'
    if @operative_record.update(operative_record_params)
      pjax_redirect_to(all_operative_records_path(@operative_record.target_day.strftime("%d%m%Y")), '[pjax-container]',
                       'success^Обновление оперативных данных прошло успешно')
    else
      @operative_record.valid?
      @errors = @operative_record.errors
      render json: @errors
      #render 'edit'
    end
  end

  def all
   # if request.headers['X-PJAX']
   #   render :layout => false #add this option to save the time of layout rendering
   # end
    @target_day = DateTime.strptime(params[:target_day], '%d%m%Y')
    td = @target_day.strftime("%d-%m-%Y")

    @records = District.find_by_sql("SELECT * FROM 
                                    (SELECT id as d_id, * FROM districts) t1 
                                    LEFT JOIN
                                    (SELECT *,
                                       all_violations_count - drunk_count - opposite_count - not_having_count 
                                       - speed_count - failure_to_footer_count - belts_count - passengers_count
                                       - tinting_count - footer_count AS other
                                    FROM operative_records WHERE target_day = date('#{td}')) t2 
                                    ON t1.id = t2.district_id
                                    LEFT JOIN 
                                    (SELECT district_id,
                                        sum(reg_emergency_count) AS reg_emergency_month,
                                        sum(dead_count) AS dead_month,
                                        sum(perished_count) AS perished_month,
                                        sum(adm_emergency_count) AS adm_emergency_month,

                                        sum(reg_emergency_child_count) AS reg_emergency_child_month,
                                        sum(dead_child_count) AS dead_child_month,
                                        sum(perished_child_count) AS perished_child_month,

                                        sum(reg_emergency_drunk_count) AS reg_emergency_drunk_month,

                                        sum(reg_emergency_footer_on_zebra_count) AS reg_emergency_footer_on_zebra_month,
                                        sum(dead_footer_on_zebra_count) AS dead_footer_on_zebra_month,
                                        sum(perished_footer_on_zebra_count) AS perished_footer_on_zebra_month,

                                        sum(all_violations_count) AS all_violations_month,
                                        sum(drunk_count) AS drunk_month,
                                        sum(opposite_count) AS opposite_month,
                                        sum(not_having_count) AS not_having_month,
                                        sum(speed_count) AS speed_month,
                                        sum(failure_to_footer_count) AS failure_to_footer_month,
                                        sum(belts_count) AS belts_month,
                                        sum(passengers_count) AS passengers_month,
                                        sum(tinting_count) AS tinting_month,
                                        sum(footer_count) AS footer_month,
                                        sum(parking_count) AS parking_month,

                                        sum(all_violations_count) - sum(drunk_count) - sum(opposite_count) - sum(not_having_count) 
                                                                  - sum(speed_count) - sum(failure_to_footer_count) 
                                                                  - sum(belts_count) - sum(passengers_count) - sum(tinting_count) 
                                                                  - sum(footer_count) AS other_month
                                       
                                      FROM operative_records 
                                      WHERE target_day BETWEEN date_trunc('month', date('#{td}')) AND date('#{td}')
                                      GROUP BY district_id) t3 
                                    ON t2.district_id = t3.district_id
                                    LEFT JOIN
                                    (SELECT district_id,
                                        sum(reg_emergency_count) AS reg_emergency_count_year,
                                        sum(dead_count) AS dead_count_year,
                                        sum(perished_count) AS perished_count_year,
                                        sum(adm_emergency_count) AS adm_emergency_count_year,

                                        sum(reg_emergency_child_count) AS reg_emergency_child_year,
                                        sum(dead_child_count) AS dead_child_year,
                                        sum(perished_child_count) AS perished_child_year,

                                        sum(reg_emergency_drunk_count) AS reg_emergency_drunk_year,

                                        sum(reg_emergency_footer_on_zebra_count) AS reg_emergency_footer_on_zebra_year,
                                        sum(dead_footer_on_zebra_count) AS dead_footer_on_zebra_year,
                                        sum(perished_footer_on_zebra_count) AS perished_footer_on_zebra_year

                                      FROM operative_records
                                      WHERE target_day BETWEEN date_trunc('year', date('#{td}')) AND date('#{td}')
                                      GROUP BY district_id) t4
                                      ON t3.district_id = t4.district_id
                                    ORDER BY d_id")

    @appg_year = District.find_by_sql("SELECT
                                  sum(reg_emergency_count) AS reg_emergency_count, 
                                  sum(dead_count) AS dead_count,
                                  sum(perished_count) AS perished_count,
                                  sum(adm_emergency_count) AS adm_emergency_count
                                  FROM operative_records  
                                  WHERE target_day BETWEEN DATE_TRUNC('year', date('#{td}') - interval '1 year') AND date('#{td}') - interval '1 year'")
    @appg_month = District.find_by_sql("SELECT
                                  sum(reg_emergency_count) AS reg_emergency_count, 
                                  sum(dead_count) AS dead_count,
                                  sum(perished_count) AS perished_count,
                                  sum(adm_emergency_count) AS adm_emergency_count
                                  FROM operative_records  
                                  WHERE target_day BETWEEN DATE_TRUNC('month', date('#{td}') - interval '1 year') AND date('#{td}') - interval '1 year'")
    @appg_day = District.find_by_sql("SELECT
                                  sum(reg_emergency_count) AS reg_emergency_count, 
                                  sum(dead_count) AS dead_count,
                                  sum(perished_count) AS perished_count,
                                  sum(adm_emergency_count) AS adm_emergency_count
                                  FROM operative_records  
                                  WHERE target_day = date('#{td}') - interval '1 year'")

    @calc_em_data = Hash.new("")
    
    @calc_em_data['reg_emergency_day'] = 0
    @calc_em_data['dead_day'] = 0

    @sum_reg_emergency_day = 0
    @sum_dead_day = 0
    @sum_perished_day = 0
    @sum_adm_emergency_day = 0

    @sum_reg_emergency_month = 0
    @sum_dead_month = 0
    @sum_perished_month = 0
    @sum_adm_emergency_month = 0

    @sum_personal_count = 0

    @sum_reg_emergency_year = 0
    @sum_dead_year = 0
    @sum_perished_year = 0
    @sum_adm_emergency_year = 0
  
    @sum_reg_emergency_child_day = 0
    @sum_reg_emergency_child_month = 0
    @sum_reg_emergency_child_year = 0

    @sum_dead_child_day = 0
    @sum_dead_child_month = 0
    @sum_dead_child_year = 0

    @sum_perished_child_day = 0
    @sum_perished_child_month = 0
    @sum_perished_child_year = 0

    @sum_reg_emergency_drunk_day = 0
    @sum_reg_emergency_drunk_month = 0
    @sum_reg_emergency_drunk_year = 0

    @sum_reg_emergency_footer_on_zebra_day = 0
    @sum_reg_emergency_footer_on_zebra_month = 0
    @sum_reg_emergency_footer_on_zebra_year = 0

    @sum_dead_footer_on_zebra_day = 0
    @sum_dead_footer_on_zebra_month = 0
    @sum_dead_footer_on_zebra_year = 0

    @sum_perished_footer_on_zebra_day = 0
    @sum_perished_footer_on_zebra_month = 0
    @sum_perished_footer_on_zebra_year = 0

    @records.each do |r|
      if r.nil? || r.district_id == 21
        next
      else
        @calc_em_data['reg_emergency_day'] += r.reg_emergency_count.to_i
        @sum_reg_emergency_day += r.reg_emergency_count.to_i
        @sum_dead_day += r.dead_count.to_i
        @sum_perished_day += r.perished_count.to_i
        @sum_adm_emergency_day += r.adm_emergency_count.to_i
  
        @sum_personal_count += r.personal_count.to_i
 
        @sum_reg_emergency_month += r.reg_emergency_month.to_i
        @sum_dead_month += r.dead_month.to_i
        @sum_perished_month += r.perished_month.to_i
        @sum_adm_emergency_month += r.adm_emergency_month.to_i

        @sum_reg_emergency_year += r.reg_emergency_count_year.to_i
        @sum_dead_year += r.dead_count_year.to_i
        @sum_perished_year += r.perished_count_year.to_i
        @sum_adm_emergency_year += r.adm_emergency_count_year.to_i

        @sum_reg_emergency_child_day += r.reg_emergency_child_count.to_i
        @sum_reg_emergency_child_month += r.reg_emergency_child_month.to_i
        @sum_reg_emergency_child_year += r.reg_emergency_child_year.to_i

        @sum_dead_child_day += r.dead_child_count.to_i
        @sum_dead_child_month += r.dead_child_month.to_i
        @sum_dead_child_year += r.dead_child_year.to_i

        @sum_perished_child_day += r.perished_child_count.to_i
        @sum_perished_child_month += r.perished_child_month.to_i
        @sum_perished_child_year += r.perished_child_year.to_i
        
        @sum_reg_emergency_drunk_day += r.reg_emergency_drunk_count.to_i
        @sum_reg_emergency_drunk_month += r.reg_emergency_drunk_month.to_i
        @sum_reg_emergency_drunk_year += r.reg_emergency_drunk_year.to_i

        @sum_reg_emergency_footer_on_zebra_day += r.reg_emergency_footer_on_zebra_count.to_i
        @sum_reg_emergency_footer_on_zebra_month += r.reg_emergency_footer_on_zebra_month.to_i
        @sum_reg_emergency_footer_on_zebra_year += r.reg_emergency_footer_on_zebra_year.to_i
      end
    end

    @hard = 0.0
    @hard_appg = 0.0

    if @sum_dead_year > 0
      @hard = @sum_dead_year.to_f / (@sum_dead_year.to_f + @sum_perished_year.to_f) * 100.0
    end

    if !@appg_year[0].dead_count.nil? && @appg_year[0].dead_count > 0
      @hard_appg = @appg_year[0].dead_count.to_f / (@appg_year[0].dead_count.to_f + @appg_year[0].perished_count.to_f) * 100
    end
    
  end

  def validate
    operative_record = OperativeRecord.new(operative_record_params)
    operative_record.valid?
    field = params[:operative_record].first[0]
    @errors = operative_record.errors[field]

    if @errors.empty?
      @errors = true
    else
      name = t("activerecord.attributes.operative_record.#{field}")
      @errors.map! { |e| "#{name} #{e}<br/>" }
    end

    respond_to do |format|
      format.json { render json: @errors }
    end 
  end

  def cafap
    get_cafap(params[:target_day])
    pjax_redirect_to(all_operative_records_path(params[:target_day]), '#operative_info', 
                     "success^Обновление данных ЦАФАП за сутки <strong> #{params[:target_day]} </strong> прошло успешно!")
  end

  def emergency_data
    if params[:target_day].length == 8
      get_emergency_data(params[:target_day])
      pjax_redirect_to(all_operative_records_path(params[:target_day]), '#operative_info', 
                       "success^Обновление данных о административных ДТП за сутки <strong> #{params[:target_day]} </strong> прошло успешно!")
    elsif params[:target_day].length == 6
      get_emergency_data_period(params[:target_day])
      pjax_redirect_to(all_operative_records_path(DateTime.yesterday.strftime('%d%m%Y')), '#operative_info', 
                       "success^Обновление данных о административных ДТП за месяц <strong> #{params[:target_day]} </strong> прошло успешно!")
    elsif params[:target_day].length == 4
      get_emergency_data_period(params[:target_day])
      pjax_redirect_to(all_operative_records_path(DateTime.yesterday.strftime('%d%m%Y')), '#operative_info', 
                       "success^Обновление данных о административных ДТП за год <strong> #{params[:target_day]} </strong> прошло успешно!")
    end
  end

  def import
#    if params[:file].nil? || params[:file] == '' 
#      msg = "warning^Необходимо выбрать файл административной практики!"
#      msg += "Обычно это последний лист в сводке, сохраненный отдельным файлом в фомате *.xlsx"
#      pjax_redirect_to(all_operative_records_path(params[:target_day]), '#operative_info', msg)
#    end
    file = params[:file]
    ext = File.extname file.path
    if ext == '.xlsx' || ext == '.xlsm'
      new_file = "public/fis_operative_data/#{DateTime.now.strftime('operative_data_%Y%m%d_%H%M%S') + ext}"
      FileUtils.cp(file.path, new_file)
      wb = Roo::Spreadsheet.open(new_file, extension: :xlsx)
      td = DateTime.strptime(params[:target_day], '%d%m%Y')
      if wb.cell(9, 1) == 'ОМВД РФ по г.Усинску'
        for i in 5..26
          if i == 25
            next
          end
          d_id = i - 4
          if i == 26
            d_id = 22
          end
          rec = OperativeRecord.where("district_id = ? AND target_day = ?", d_id, td).take
          if rec.nil?
            rec = OperativeRecord.new
            rec.district_id = d_id
            rec.target_day = td
          end
          rec.user_id = current_user.id
      #    rec.reg_emergency_count =  wb.cell(i, 2)
      #    rec.dead_count =  wb.cell(i, 3)
      #    rec.perished_count = wb.cell(i, 4) 
      #    rec.adm_emergency_count =  wb.cell(i, 5)
          rec.personal_count =  wb.cell(i, 10)
          rec.all_violations_count =  wb.cell(i, 12)
          rec.drunk_count = wb.cell(i, 15) 
          rec.opposite_count = wb.cell(i, 17)
          rec.not_having_count = wb.cell(i, 19)
          rec.speed_count = wb.cell(i, 21)
          rec.failure_to_footer_count = wb.cell(i, 23)
          rec.belts_count = wb.cell(i, 25)
          rec.passengers_count = wb.cell(i, 27)
          rec.tinting_count = wb.cell(i, 29)
          rec.footer_count = wb.cell(i, 31)
          rec.arrested_day_count = wb.cell(i, 35)
          rec.arrested_all_count = wb.cell(i, 36)
          rec.parking_count = wb.cell(i, 37)
          rec.source = 'adv_oper_data'
          rec.save
        end
      else
        td = DateTime.strptime(wb.cell(9, 1)[-10, 10], '%d.%m.%Y')
        i = 19 
        str = ''
        districts = District.all
        while wb.cell(i, 2) != nil do 
          districts.each do |d|
            if d.name == wb.cell(i, 2)
              if d.id == 21 #CAFAP
                next
              end
              rec = OperativeRecord.where("district_id = ? AND target_day = ?", d.id, td).take
              if rec.nil?
                rec = OperativeRecord.new
                rec.district_id = d.id
                rec.target_day = td
              end
              rec.user_id = current_user.id
              rec.all_violations_count = wb.cell(i, 3)
              rec.speed_count = wb.cell(i, 15)
              rec.not_having_count = wb.cell(i, 19)
              rec.drunk_count = wb.cell(i, 7).to_i + wb.cell(i, 11).to_i
              rec.source = 'fis'
              rec.save
              break
            end
          end
          i = i + 1
        end
      end
      pjax_redirect_to(all_operative_records_path(params[:target_day]), '#operative_info', 
                       "success^Импорт данных за <strong> #{params[:target_day]} </strong> прошел успешно!")
    else
      render text: 'not this file i exppected!!!'
    end
  end

  private

  def get_cafap(date, ott = nil)
    day = DateTime.strptime(date, '%d%m%Y')
    rec = OperativeRecord.where(district_id: 21).where(target_day: day).take
    discon_here = false
    if rec.nil?
      rec = OperativeRecord.new
      rec.target_day = day
      rec.district_id = 21 
    end
    rec.user_id = current_user.id
    if ott.nil?
      ott = ott_conn
      discon_here = true
    end
    rec.get_cafap(ott)
    if discon_here
      oci_disconn(ott)
    end
    rec.save
  end

  def get_emergency_data_period(date)
    aius = aius_conn
    if date.length == 4
      begin_day = DateTime.strptime('0101' + date, '%d%m%Y')
      end_day = DateTime.strptime('3112' + date, '%d%m%Y')
    elsif date.length == 6
      begin_day = DateTime.strptime('01' + date, '%d%m%Y')
      end_day = begin_day + 1.month - 1.day
    end
    if end_day > DateTime.yesterday
      end_day = DateTime.yesterday
    end
    begin_day.upto(end_day) do |day|
      get_emergency_data(day.strftime('%d%m%Y'), aius)
    end
    oci_disconn(aius)
  end

  def get_emergency_data(date, aius = nil)
    day = DateTime.strptime(date, '%d%m%Y')
    disconn_here = false
    if aius.nil?
      aius = aius_conn
      disconn_here = true
    end
    District.all.each do |d|
      if d.id == 21
        next
      end
      rec = OperativeRecord.where(district_id: d.id).where(target_day: day).take
      if rec.nil?
        rec = OperativeRecord.new
        rec.target_day = day
        rec.district_id = d.id
      end
      rec.user_id = current_user.id
      rec.get_emergency_data(aius)
      rec.save
    end
    if disconn_here
      oci_disconn(aius)
    end
  end  

  def operative_record_params
    params.require(:operative_record).permit(:target_day, :reg_emergency_count, :dead_count, :perished_count, :adm_emergency_count, 
                                             :personal_count, :all_violations_count,
                                             :drunk_count, :opposite_count, :not_having_count, :speed_count, :failure_to_footer_count,
                                             :belts_count, :passengers_count, :tinting_count, :footer_count, :arrested_day_count, :arrested_all_count,
                                             :parking_count, :article_264_1_count, :oop_count, :solved_crime_count,
                                             :stealing_autos, :theft_autos, :stealing_solved, :theft_solved, :stealing_solved_gibdd, :theft_solved_gibdd,
                                             :district_id)
  end

end
