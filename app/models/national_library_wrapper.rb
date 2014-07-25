require 'nokogiri'
require 'uri'
require 'open-uri'
require 'mechanize'

# Wrapper around the National Library API
# The API is documented here http://www.nb.no/services/search/v2/
class NationalLibraryWrapper

	def initialize(query)
		@query = query
		@doc = fetch_doc(0)
		number_of_results
	end

	def search(page=0)
		# Ideally, we would use the id element as url for the reference, but this url always
		# leads to a 404
		fetch_doc(page).css("entry").map do |i| 
			Reference.new(
				'reference_source_id' => 1,
				'reference_type_id'   => ReferenceType.determine_type_id(i.css("mediatype").text),
				'title' 			  => i.css("title").text,				
				'creator' 			  => i.css("namecreator").text,
				'lang' 				  => "und",
				'snippet' 			  => i.css("summary").text,
				'url' 				  => "http://urn.nb.no/" + i.css('urn').text.scan(/[^;]+/).first,
				'year' 				  => i.css("year").empty? ? nil : i.css("year").text.to_i 	# Cast to integer if exists
			)			
		end		
	end

	def number_of_results
		# Matches last digits in string of form: <subtitle type=\"text\">Nasjonalbibliotekets general Search API for client applications, results: 1 - 10 of 565</subtitle>
		return @doc.css("subtitle").text.scan(/\d+/).last.to_i
	end

	def self.determine_type_id_from_url(url)
		agent = Mechanize.new
		agent.get(url)

		reference_type = agent.page.parser.css("div:nth-child(19) .preview_metadata_data").text.strip

		return ReferenceType::determine_type_id(reference_type)
	end

	def self.new_reference_from(url)
		# We use mechanize instead of just fetching the page and scraping it with nokogiri
		# because the pages are redirected to a authentication manager (OpenAM) and back to the url.
		# Redirection causes open-uri to fail with a runtime error, as redirection is forbidden.
		# Mechanize let us ignore this issue.
		agent = Mechanize.new
		agent.keep_alive = false
		agent.get(url)

		title = agent.page.parser.css('title').text.delete("\n").split("-")[0].strip
		
		# Regex grabs anything that looks like a year
		# This code is very fragile, but there does not seems to be any better way
		year = nil
		agent.page.parser.xpath("//meta[@name='dc:date']/@content").each do |attr|
			year = attr.value
			break if not year.nil?
		end

		creator = agent.page.parser.css('.tableRow .fakeLink').text.strip

		Reference.new(
			'reference_source_id' => 1,
			'title' 	=> title,
			'creator' 	=> creator,
			'lang' 		=> 'und',
			'snippet'	=> '',
			'url' 		=> url,
			'year' 		=> year
		)
	end

	private

	def fetch_doc(page=0)
		page = page.to_i

		itemsPerPage = 10
		startIndex = page * itemsPerPage

		# Facets are available, while not properly documented, to filter for digital entries, use ditigal:ja
		# http://www.nb.no/services/search/v2/search?q=foyn&filter=digital:ja
		q = URI.encode(@query)
		search_url = "http://www.nb.no/services/search/v2/search?filter=digital:ja&q=#{q}&startIndex=#{startIndex}&ft=true&itemsPerPage=#{itemsPerPage}"

		# Fetch search results, fail on malformed XML
		doc = Nokogiri::XML(WrapperHelper::fetch_http(search_url)) do |conf|
			conf.strict
		end

		# All NB specific elements include a namespace which is repeated for *every* element.
		# Example: <nb:digital xmlns:nb="http://www.nb.no/xml/search/1.0/">true</nb:digital>
		# (It doesn't need to be repeated for every element, the URI leads to a 404 and we're
		# actually using version 2 of the API anyway.)
		# To simplify XML handling, we ignore namespaces.
		# As of november 2012, this has not caused any problems.
		doc.remove_namespaces!

		return doc
	end
end