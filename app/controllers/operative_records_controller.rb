class OperativeRecordsController < ApplicationController

  load_and_authorize_resource

#  before_action :set_article, only: [ :show, :edit, :update, :destroy ]

  def index
    @operative_records = OperativeRecord.where(user_id: current_user.id).order(:target_day)
  end

  def show
    @operative_record = OperativeRecord.find(params[:id])
  end

  def new
    @operative_record = OperativeRecord.new
  end  

  def edit
  end

  def create
    @operative_record = OperativeRecord.new(operative_record_params)
    @operative_record.user_id = current_user.id
    @operative_record.save
    redirect_to @operative_record
  end

  def update
  end

  def destroy
  end

  private

  def operative_record_params
    params.require(:operative_record).permit(:target_day, :registry_emergency_count, :dead_count, 
                                             :perished_count, :adm_emergency_count, :personal_count, :all_violations_count,
                                             :drunk_count, :opposite_count, :not_having_count, :speed_count, :failure_to_footer_count,
                                             :belts_count, :passengers_count, :tinting_count, :footer_count, :arested_day_count, :arested_all_count,
                                             :parking_count, :article_264_1_count, :oop_count, :solved_crime_count,
                                             :stealing_autos, :theft_autos, :stealing_sloved, :theft_sloved, :stealing_sloved_gibdd, :theft_sloved_gibdd,
                                             :district_code)
  end

end
