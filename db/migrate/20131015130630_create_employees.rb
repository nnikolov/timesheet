class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :password
      t.boolean :active, default: true
      t.boolean :admin
      t.integer :timeout, default: 60

      t.timestamps
    end
    e = Employee.new(first_name: 'Admin', last_name: 'Admin', username: 'admin', password: 'password', admin: true, timeout: 60)
    e.save
  end
end
