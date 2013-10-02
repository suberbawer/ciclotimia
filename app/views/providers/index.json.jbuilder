json.array!(@providers) do |provider|
  json.extract! provider, :name, :lastname, :phone, :email, :address, :ci
  json.url provider_url(provider, format: :json)
end
