json.array!(@productoras) do |productora|
  json.extract! productora, :id, :name, :rut, :billing_name
  json.url productora_url(productora, format: :json)
end
