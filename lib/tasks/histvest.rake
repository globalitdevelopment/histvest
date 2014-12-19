namespace :histvest do

	desc 'Geocode pending people'
	task geocode_pending_people: :environment do
		puts "Geocoding pending people"
		Person.geocode_pending
	end

end