class Admin::TimeEntriesController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update, :destroy]

  # GET /time_entries
  # GET /time_entries.json
  def index
    @time_entries = TimeEntry.where("entry_date > :entry_date", entry_date: Date.today - 2.weeks).order("entry_date desc, employee_id, start_time")
  end

  # GET /time_entries/1
  # GET /time_entries/1.json
  def show
  end

  # GET /time_entries/new
  def new
    begin
      entry_date = Date.parse params[:id]
    rescue
      entry_date = Date.today
    end
    start_time = "#{entry_date} 08:00:00"
    end_time = "#{entry_date} 16:00:00"
    @time_entry = TimeEntry.new(entry_date: entry_date, employee_id: @logged_in, start_time: start_time, end_time: end_time)
  end

  # GET /time_entries/1/edit
  def edit
    @time_entry.to_local
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)

    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to admin_time_entry_path(@time_entry), notice: 'Time entry was successfully created.' }
        format.json { render action: 'show', status: :created, location: @time_entry }
      else
        format.html { render action: 'new' }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /time_entries/1
  # PATCH/PUT /time_entries/1.json
  def update
    respond_to do |format|
      if @time_entry.update(time_entry_params)
        format.html { redirect_to admin_time_entry_path(@time_entry), notice: 'Time entry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @time_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /time_entries/1
  # DELETE /time_entries/1.json
  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to admin_time_entries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_entry
      @time_entry = TimeEntry.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_entry_params
      params.require(:time_entry).permit(:employee_id, :start_time, :end_time, :entry_date)
    end
end
