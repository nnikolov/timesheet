class Employee < ActiveRecord::Base
  validates :first_name, length: { minimum: 2 }
  validates :last_name, length: { minimum: 2 }
  validates :username, length: { minimum: 2 }
  validates :password, length: { minimum: 4 }, on: :create
  validates :timeout, numericality: true
  has_many :time_entries
  before_save EncryptionWrapper.new("username", "password")
  attr_accessor :current_password, :new_password, :confirm_password

  def self.authenticate(params)
    e = EncryptionWrapper.new(params[:username], params[:password])
    self.where(username: params[:username]).first.password == e.encrypted_string
    rescue
      false
  end

  def self.with_time_entries(params = {})
    start_end = self.set_start_end(params)
    start_date = params[:start_date] ? params[:start_date] : Date.today - 2.weeks
    end_date = params[:end_date] ? params[:end_date] : Date.yesterday
    self.joins('LEFT OUTER JOIN time_entries ON time_entries.employee_id = employees.id').where("entry_date >= :start_date AND entry_date <= :end_date", {start_date: start_end[:start_date], end_date: start_end[:end_date]}).distinct.order("first_name, last_name")
  end

  def total_hours_worked(params = {})
    start_end = self.class.set_start_end(params)
    time_entries.where("entry_date >= :start_date AND entry_date <= :end_date",
      {start_date: start_end[:start_date], end_date: start_end[:end_date]}).sum(:hours_worked)
  end

  def day_entries(day)
    time_entries.where("entry_date = :day", {day: day}).order(:start_time)
  end

  def change_password(params)
    unless Employee.authenticate(username: self.username, password: params[:current_password])
      errors.add(:current_password, "is not valid")
    end
    unless params[:new_password].size > 4
      errors.add(:new_password, "must be at least 4 characters long")
    end
    unless params[:new_password] == params[:confirm_password]
      errors.add(:confirm_password, "does not match new password")
    end
    if self.errors.size > 0
      return false
    end
    self.password = params[:new_password]
    self.save
  end

  private

  def self.set_start_end(params)
    start_date = params[:start_date] ? params[:start_date] : Date.today - 2.weeks
    end_date = params[:end_date] ? params[:end_date] : Date.yesterday
    {start_date: start_date, end_date: end_date}
  end
end
