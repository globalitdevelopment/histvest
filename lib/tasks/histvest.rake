namespace :histvest do

	desc 'Geocode pending people'
	task geocode_pending_people: :environment do
		puts "Geocoding pending people"
		Person.geocode_pending
	end

	desc 'Check reference links status'
	task check_reference_links: :environment do
		puts "Checking link "
		Referece.update_url_statuses
	end

end