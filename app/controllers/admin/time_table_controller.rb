class Admin::TimeTableController < ApplicationController
  before_action :set_start_end_dates, only: [:index, :update]

  def index
    @employees = Employee.with_time_entries(start_date: @start_date, end_date: @end_date)
  end

  def update
    redirect_to time_table_range_path(@start_date.strftime("%Y%m%d"), @end_date.strftime("%Y%m%d"))

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_start_end_dates
      set_start_date
      set_end_date
    end

    def set_start_date
      if params[:action] == 'update'
        @start_date = Date.parse "#{params[:start_date][:year]}-#{params[:start_date][:month]}-#{params[:start_date][:day]}"
      else
        @start_date = Date.parse(params[:start_date])
      end
      rescue
        @start_date = Date.today - 2.weeks
    end

    def set_end_date
      if params[:action] == 'update'
        @end_date = Date.parse "#{params[:end_date][:year]}-#{params[:end_date][:month]}-#{params[:end_date][:day]}"
      else
        @end_date = Date.parse(params[:end_date])
      end
      rescue
        @end_date = Date.today - 1.day
    end
end
