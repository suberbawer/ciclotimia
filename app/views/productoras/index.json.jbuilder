json.array!(@productoras) do |productora|
  json.extract! productora, :id, :name, :rut, :address
  json.url productora_url(productora, format: :json)
end
