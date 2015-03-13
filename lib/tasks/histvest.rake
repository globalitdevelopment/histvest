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

	desc 'Task to crawl census and have more data'
	task search_more_people: :environment do
		names = Person.distinct.where("random() < 0.1").limit(10).pluck :name
		names.each do |fullname|
			fornavn, etternavn = Person.parse_name fullname
			regions = Person::VESTFOLD.sample(5)
			(1..20).each do |page|
				break if Person.search(fornavn: fornavn, page: page, k: regions).empty?
			end
			(1..20).each do |page|
				break if Person.search(etternavn: etternavn, page: page, k: regions).empty?
			end
		end
		Person.geocode_pending
	end

end
