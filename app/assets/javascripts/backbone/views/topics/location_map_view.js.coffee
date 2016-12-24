Histvest.Views.Topics ||= {}

class Histvest.Views.Topics.LocationMapView extends Backbone.GoogleMaps.MarkerCollectionView
	
	el: '#map_div'

	tagName: 'ul'

	template: JST["backbone/templates/topics/location_input"]

	events:
		"click #marker_toggle" 		: 'addMarker' 
		"click #marker_adder"  		: 'focusLocationInput'
		"click a.remove-location" 	: 'removeLocation'
		"click a.zoom-location" 	: 'zoomLocation'
		"click #add-location" 		: 'addLocation'
		"keypress #add-location-input" : 'addLocationKey'

	constructor: (opts={})->
		super opts
		@collection.on('reset', @render, this)
		@collection.on('add', @appendLocation, this)
		@collection.on('remove', @render, this)		
		@collection.on('change:selected', @render, this)
		@collection.on('change', @updateLocation, this)

		# bind autocomplete
		$("#add-location-input").autocomplete
			source: (request, response)-> 
				window.geocoder.geocode( address: request.term, (results, status) ->
					response($.map(results, (item)-> 
						label:  item.formatted_address
						value: item.formatted_address
						lat: item.geometry.location.lat()
						lng: item.geometry.location.lng()
					))
				)        						

	render: ->
		super(@collection)
		$('#locations-list-container li').remove()				
		@collection.each(@appendLocation)								
			
	appendLocation: (location) =>		
		if(location.get('selected'))		
			if $.trim(location.get("title")) == '' and $.trim(location.get("geo_address")) == ''
				location.set('geo_address','...')
				window.geocoder.geocode latLng: location.getLatLng(), (results, status) =>
	            	if status == google.maps.GeocoderStatus.OK and results.length > 0
	               		location.set('geo_address', results[0].formatted_address)
	               		location.get('gOverlay').setTitle(results[0].formatted_address)

			$('#locations-list-container').append(@template(location: location))
			$('#locations-list-container li[data-id='+location.cid+'] > div').effect('highlight')			


	updateLocation: (location) =>
		$('#locations-list-container li[data-id='+location.cid+']').replaceWith(@template(location: location))	
		$('#locations-list-container li[data-id='+location.cid+'] > div').effect('highlight')

	# testing code
	removeLocation: (e)-> 		
		id = $(e.target).parents('li').first().data('id')						
		model = @collection.get(id)
		model.deselect()				

	zoomLocation: (e)->
		id = $(e.target).parents('li').first().data('id')								
		model = @collection.get(id)	
		@zoomMarker(model)		

	focusLocationInput: ->				
		$('#add-location-input').focus()

	addMarker: ->
		marker = new Histvest.Models.LocationMarker
			title: window.map.getCenter().lat() + ', ' + window.map.getCenter().lng()
			lat: window.map.getCenter().lat()
			lng: window.map.getCenter().lng()
			selected: true
			is_new: true			

		@collection.add(marker)
		marker.animate()
		

	addLocation: ->
		val = $.trim($('#add-location-input').val())

		if val == ''
			return false

		$('.search-box').animate(opacity: 0.5)
		window.geocoder.geocode( address: val, (results, status)=>
			if results.length > 0 
				item = results[0]
				marker_location = new google.maps.LatLng(item.latitude, item.longitude)
				marker = new Histvest.Models.LocationMarker
					title: val
					lat: item.geometry.location.lat()
					lng: item.geometry.location.lng()
					selected: true
					is_new: true			
				@collection.add(marker)
				@zoomMarker(marker)
				$("#add-location-input").val('')				
			else
				alert("address not found")

			$('.search-box').animate(opacity: 1)
		)	

	addLocationKey: (e)->
		if e.which == 13
			e.preventDefault()
			@addLocation()
			return false

	zoomMarker: (marker)->
		@map.setCenter(marker.getLatLng())
		if @map.getZoom() < 12 then	@map.setZoom(12)
		marker.animate()