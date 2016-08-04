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
    @district = District.find(district_id)
    @operative_records = OperativeRecord.where(district_id: district_id).order('target_day desc')
  end

  def new
    @districts = District.all
    @saved_operative_records = OperativeRecord.where(district_id: current_user.district_id).order('target_day desc').limit(31).reverse
    @operative_record = OperativeRecord.new
    if !params[:target_day].nil?
      @target_day = DateTime.strptime(params[:target_day], '%d%m%Y')
      @operative_record.target_day = @target_day
    end
  end  

  def edit
    @districts = District.all
    @saved_operative_records = OperativeRecord.where(district_id: current_user.district_id).order('target_day desc').limit(31).reverse
  end

  def create
    @operative_record = OperativeRecord.new(operative_record_params)
    @operative_record.user_id = current_user.id
    if current_user.district_id.between?(1, 20)
      @operative_record.district_id = current_user.district_id
    end
    if @operative_record.save
      pjax_redirect_to operative_records_path
    else
#      @districts = District.all
#      @saved_operative_records = OperativeRecord.where(district_id: current_user.district_id).order('target_day desc').limit(31).reverse
      @operative_record.valid?
      @errors = @operative_record.errors
      render json: @errors
#      render 'new'
    end
  end

  def update
    @operative_record = OperativeRecord.find(params[:id])
    if @operative_record.update(operative_record_params)
      pjax_redirect_to operative_records_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  def all
    if params[:target_day] == 'now'
      # @target_day =  DateTime.now
      @target_day =  DateTime.yesterday
    else
      @target_day = DateTime.strptime(params[:target_day], '%d%m%Y')
    end
    td = @target_day.strftime("%d-%m-%Y")
    @records = District.find_by_sql( "SELECT * FROM 
                                     (SELECT id as d_id, * FROM districts) t1 LEFT JOIN 
                                     (SELECT * FROM operative_records 
                                     WHERE target_day = date '#{td}') t2 ON t1.id = t2.district_id" )
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

  private

  def operative_record_params
    params.require(:operative_record).permit(:target_day, :registry_emergency_count, :dead_count, 
                                             :perished_count, :adm_emergency_count, :personal_count, :all_violations_count,
                                             :drunk_count, :opposite_count, :not_having_count, :speed_count, :failure_to_footer_count,
                                             :belts_count, :passengers_count, :tinting_count, :footer_count, :arested_day_count, :arested_all_count,
                                             :parking_count, :article_264_1_count, :oop_count, :solved_crime_count,
                                             :stealing_autos, :theft_autos, :stealing_sloved, :theft_sloved, :stealing_sloved_gibdd, :theft_sloved_gibdd,
                                             :district_id)
  end

end
