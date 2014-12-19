require 'nokogiri'
require 'uri'
require 'mechanize'

class DigitalArchiveWrapper

	def initialize(query)
		@query = query
		@doc = fetch_doc(0)
		number_of_results
	end

	def search(page=0)
		# Ideally, we would use the id element as url for the reference, but this url always
		# leads to a 404
		fetch_doc(page).css("table.searchResultTable tbody tr").map do |i| 
				
			# determine year as birth year
			matches = i.css('td')[1].text.scan(/\b\d{4}\b/)
			
			Reference.new(
				'reference_source_id' => 4,
				'reference_type_id'   => ReferenceType.determine_type_id('person'),
				'title' 			  => i.css('td')[0].text,				
				'creator' 			  => i.css('td')[2].text,
				'lang' 				  => "und",
				'snippet' 			  => i.css('td')[3].text,
				'url' 				  => i.css('td a')[0].attribute('href').value,
				'year' 				  => (matches.size > 0 ? matches[0].to_i : nil)
			)			
		end		
	end

	def number_of_results
		# Matches last digits in string of form: <subtitle type=\"text\">Nasjonalbibliotekets general Search API for client applications, results: 1 - 10 of 565</subtitle>
		return @doc.css("div.resultTablePage p.comment.standalone").text.scan(/\d+/).first.to_i
	end

	def self.new_reference_from(url)
		# We use mechanize instead of just fetching the page and scraping it with nokogiri
		# because the pages are redirected to a authentication manager (OpenAM) and back to the url.
		# Redirection causes open-uri to fail with a runtime error, as redirection is forbidden.
		# Mechanize let us ignore this issue.
		agent = Mechanize.new
		agent.keep_alive = false
		agent.get(url)

		title = agent.page.parser.css('div.resultTablePage h4').first.text.strip
		
		# here creator is storing the origin of person
		creator = get_text_with_label agent.page.parser, "Fødested:"

		matches = get_text_with_label(agent.page.parser, "Fødselsdato:").scan(/\b\d{4}\b/)


		Reference.new(
			'reference_source_id' => ReferenceSource.find_by!(name: "Digitalarkivet").id,
			'reference_type_id' => ReferenceType.find_by!(name: "Person").id,
			'title' 	=> title,
			'creator' 	=> creator,
			'lang' 		=> 'und',
			'snippet'	=> '',
			'url' 		=> url,
			'year' 		=> (matches.size > 0 ? matches[0].to_i : nil)
		)
	end

	private

	def fetch_doc(page=0)
		# Facets are available, while not properly documented, to filter for digital entries, use ditigal:ja
		# http://www.nb.no/services/search/v2/search?q=foyn&filter=digital:ja
		q = URI.encode(@query)
		search_url = "http://digitalarkivet.arkivverket.no/sok/person?s=#{q}&page=#{page}"

		doc = Nokogiri::XML(WrapperHelper::fetch_http(search_url))
		
		return doc
	end

	def self.get_text_with_label(parser, label)
		nodes = parser.css('table.infotable td')
		nodes.each { |td| return nodes[nodes.index(td)+1].text if td.text.strip == label.strip }
		""
	end

end