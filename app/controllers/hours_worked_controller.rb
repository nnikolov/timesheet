class HoursWorkedController < ApplicationController
  before_action :set_time_entry, only: [:show, :edit, :update]

  ## GET /time_entries
  ## GET /time_entries.json
  #def index
  #  @time_entries = TimeEntry.all
  #end

  ## GET /time_entries/1
  ## GET /time_entries/1.json
  #def show
  #end

  # GET /time_entries/new
  def new
    begin
      entry_date = Date.parse params[:id]
      entry_date = entry_date > Date.today ? Date.today : entry_date
      entry_date = entry_date < Date.today - 2.weeks ? Date.today - 2.weeks : entry_date
    rescue
      entry_date = Date.today
    end
    start_time = Time.local(entry_date.strftime("%Y"),entry_date.strftime("%m"),entry_date.strftime("%d"),4)
    end_time = Time.local(entry_date.strftime("%Y"),entry_date.strftime("%m"),entry_date.strftime("%d"),12)

    @time_entries = TimeEntry.where(entry_date: entry_date, employee_id: @logged_in).order("start_time")
    @time_entry = TimeEntry.new(entry_date: entry_date, employee_id: @logged_in, start_time: start_time, end_time: end_time)
    @curr_day = @time_entry.entry_date
    @prev_day = @time_entry.entry_date.prev_day unless @time_entry.entry_date.prev_day < Date.today - 2.weeks
    @next_day = @time_entry.entry_date.next_day unless @time_entry.entry_date.next_day > Date.today
  end

  # GET /time_entries/1/edit
  def edit
  end

  # POST /time_entries
  # POST /time_entries.json
  def create
    @time_entry = TimeEntry.new(time_entry_params)
    @time_entry.employee_id = @logged_in
    @time_entry.entry_date = params[:id]
    @curr_day = @time_entry.entry_date
    @prev_day = @time_entry.entry_date.prev_day
    @next_day = @time_entry.entry_date.next_day
    @time_entries = TimeEntry.where(entry_date: @curr_day, employee_id: @logged_in).order("start_time")

    respond_to do |format|
      if @time_entry.save
        format.html { redirect_to hours_worked_path(@time_entry.edate), notice: 'Time entry was successfully created.' }
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
        format.html { redirect_to hours_worked_path(@time_entry.entry_date.strftime("%Y%m%d")), notice: 'Time entry was successfully updated.' }
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
    @time_entry = TimeEntry.find(params[:id])
    edate = @time_entry.edate
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to hours_worked_url(edate) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_time_entry
      @time_entry = TimeEntry.where(entry_date: params[:id], employee_id: @logged_in).first
      #@time_entry = TimeEntry.find_or_new(entry_date: params[:id], employee_id: @logged_in)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def time_entry_params
      params.require(:time_entry).permit(:employee_id, :start_time, :end_time, :entry_date)
    end
end
