class Histvest.Models.References extends Backbone.Model

  # When creating the input tags,we need to fill name="topic[references_attributes][*THIS*][url]
  # with something other than the empty string, because Rack gets confused when there already exists data.
  # See: http://stackoverflow.com/questions/11445831/how-to-submit-multiple-new-items-via-rails-3-2-mass-assignment
  trueIdOrRandomId: ->
    if @id
      return @id
    else
      if @randomId
        return @randomId
      else
        @randomId = Math.floor(Math.random()*100000)
        return @randomId

class Histvest.Collections.AddedReferencesCollection extends Backbone.Collection
  model: Histvest.Models.References

  addPreviouslyAddedReferences: (id) ->
    $.getJSON('/topics/' + id, (data) =>
      @.add(data.references)
    )

class Histvest.Collections.ReferencesCollection extends Backbone.Collection
  model: Histvest.Models.References

  search: (sq, range) ->        
    @trigger "search"
    @query = sq
    @range = range
    @fetch()
    @getNumberOfResults()

  getNumberOfResults: ->
    if (typeof @query == "string")
      $.getJSON('/references/numberOfResults' + @sourceName + '/' + @query, (data) =>
        @numberOfResults = data
        @trigger "getNumberOfResults"
      )
    else
      @numberOfResults = "nope"
  
class Histvest.Collections.NbReferencesCollection extends Histvest.Collections.ReferencesCollection

  initialize: ->
    @spinnerIcon = '#spinner-container-nb'
    @sourceName = 'Nb'

  url: ->
    "/references/search/NationalLibrary/" + @range + "/" + @query
    
class Histvest.Collections.WikiReferencesCollection extends Histvest.Collections.ReferencesCollection

  initialize: ->
    @spinnerIcon = '#spinner-container-wiki'
    @sourceName = 'Wiki'

  url: ->
    "/references/search/Wikipedia/" + @range + "/" + @query
    

class Histvest.Collections.EuropeanaReferencesCollection extends Histvest.Collections.ReferencesCollection

  initialize: ->
    @spinnerIcon = '#spinner-container-europeana'
    @sourceName = 'Euro'

  url: ->
    "/references/search/Europeana/" + @range + "/" + @query

class Histvest.Collections.DaReferencesCollection extends Histvest.Collections.ReferencesCollection

  initialize: ->
    @spinnerIcon = '#spinner-container-da'
    @sourceName = 'Da'

  url: ->
    "/references/search/DigitalArchive/" + @range + "/" + @query