Histvest.Views.Topics ||= {}

class Histvest.Views.Topics.SearchFormView extends Backbone.View
	template: JST["backbone/templates/topics/search_form"]

	events:
		'submit form#reference-search-form': 'searchForReferences'

	initialize: (options) ->
		@nb_references = new Histvest.Collections.NbReferencesCollection()
		new Histvest.Views.Topics.SearchResultView(
			collection: @nb_references,
			addedReferences: options.added_references_collection,
			el: '#nb-reference-table'
		)

		@wiki_references = new Histvest.Collections.WikiReferencesCollection()
		new Histvest.Views.Topics.SearchResultView(
			collection: @wiki_references,
			addedReferences: options.added_references_collection,
			el: '#wiki-reference-table'
		)

		@europeana_references = new Histvest.Collections.EuropeanaReferencesCollection()
		new Histvest.Views.Topics.SearchResultView(
			collection: @europeana_references,
			addedReferences: options.added_references_collection,
			el: '#europeana-reference-table'
		)

		@da_references = new Histvest.Collections.DaReferencesCollection()
		new Histvest.Views.Topics.SearchResultView(
			collection: @da_references,
			addedReferences: options.added_references_collection,
			el: '#da-reference-table'
		)

	render: ->
		$(@el).html(@template())
		this

	searchForReferences: (event) ->
		event.preventDefault()
		query = $('#reference-search').val()

		if $.trim(query) == ''
			alert("Vennligst skriv sikt å søke.")
			return false

		#start page
		range = 0

		@nb_references.search(query, range)
		@wiki_references.search(query, range)
		@europeana_references.search(query, range)
		@da_references.search(query, range)

 
