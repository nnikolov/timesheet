json.array!(@time_entries) do |time_entry|
  json.extract! time_entry, :employee_id, :hours, :entry_date
  json.url time_entry_url(time_entry, format: :json)
end
