class CreateTimeEntries < ActiveRecord::Migration
  def change
    create_table :time_entries do |t|
      t.string :employee_id
      t.datetime :start_time
      t.datetime :end_time
      t.date :entry_date
      t.decimal :hours_worked, precision: 10, scale: 2

      t.timestamps
    end
  end
end
