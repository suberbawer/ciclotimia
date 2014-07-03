json.array!(@staffs) do |staff|
  json.extract! staff, :id, :name, :lastname, :productora_id, :phone
  json.url staff_url(staff, format: :json)
end
