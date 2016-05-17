class TimeEntry < ActiveRecord::Base
  validate :end_time_greater_than_start_time, :time_entries_cannot_overlap
  belongs_to :employee, class_name: 'Employee', foreign_key: 'employee_id'
  before_save :to_utc, :calculate_hours_worked

  def edate
    self.entry_date.strftime("%Y%m%d")
  end

  def total_hours_worked
    TimeEntry.where(employee_id: self.employee_id, entry_date: self.entry_date).sum(:hours_worked)
  end

  def overlap?(start_time, end_time)
    # http://stackoverflow.com/questions/325933/determine-whether-two-date-ranges-overlap
    (self.start_time < end_time) and (self.end_time > start_time)
  end

  def to_local
    self.end_time = convert_to_local(self.end_time)
    self.start_time = convert_to_local(self.start_time)
  end

  private

  def end_time_greater_than_start_time
    if self.start_time > self.end_time
      errors.add(:end_time, "must be greater than or equal to start time")
    end
  end

  def time_entries_cannot_overlap
    utc_start = convert_to_utc(self.start_time)
    utc_end = convert_to_utc(self.end_time)
    TimeEntry.where(employee_id: self.employee_id, entry_date: self.entry_date).order(:start_time).each do |time_entry|
      if time_entry.overlap?(utc_start, utc_end)
        if self.id == nil or self.id != time_entry.id
          errors.add(:start_time, " and end time cannot overlap #{time_entry.start_time.localtime.strftime("%H:%M")} - #{time_entry.end_time.localtime.strftime("%H:%M")}.")
        end
      end
    end
  end

  def to_utc
    self.end_time = convert_to_utc(self.end_time)
    self.start_time = convert_to_utc(self.start_time)
  end

  def convert_to_utc(ltime)
    Time.parse ltime.strftime("%Y-%m-%d %H:%M:00 #{Time.now.strftime('%z')}")
  end

  def convert_to_local(time)
    Time.parse time.localtime.strftime("%Y-%m-%d %H:%M:00 UTC")
  end

  def calculate_hours_worked
    self.hours_worked = ((self.end_time - self.start_time) / 1.hour).round(2)
  end
end
