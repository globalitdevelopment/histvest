every 6.hours do
  rake 'histvest:search_more_people'
  rake 'histvest:geocode_pending_people'
end

every :day do
  rake 'histvest:check_reference_links'
end
