every 4.hours do
  rake 'histvest:search_more_people'
  rake 'search:index'
end

every :day do
  rake 'histvest:geocode_pending_people'
  rake 'histvest:check_reference_links'
end
