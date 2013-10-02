json.array!(@articles) do |article|
  json.extract! article, :description, :estimated_price, :entry_date, :commission_per, :commission_cash, :status
  json.url article_url(article, format: :json)
end
