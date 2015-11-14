if events.event
  json.extract! events.event, :id, :name, :paid, :payment_amount, :start_date, :end_date
end
json.location do
  if events.location
    json.extract! events.location, :latitude, :longitude, :address
  end
end




