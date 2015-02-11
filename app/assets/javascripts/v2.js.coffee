#= require jquery
#= require jquery_ujs
#= require bootstrap/bootstrap
#= require angular/angular
#= require leaflet/leaflet
#= require leaflet.markercluster

$('#map').height $(window).height() - 50
$('#results').height $(window).height() - 129
$(window).resize -> 
	$('#map').height $(window).height() - 50
	$('#results').height $(window).height() - 120

map = L.map 'map',
	center: [59.28078619999999, 10.1144355]
	zoom: 10
	minZoom: 8
	maxZoom: 17
	maxBounds: L.latLngBounds L.latLng(71.30079291637452, 32.7392578125), L.latLng(51.67255514839676, 0.3076171875)

@map = map

L.tileLayer('http://{s}.tile.osm.org/{z}/{x}/{y}.png',
  attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
).addTo(map);

mapApp = angular.module 'mapApp', []

mapApp.controller 'mapCtrl', ['$scope', '$http', '$templateCache', '$compile', '$timeout', ($scope, $http, $templateCache, $compile, $timeout)->	
	$scope.showTopics = true
	$scope.showPeople = true
	$scope.people = []
	
	@prepareMarker = (location)->
		marker = L.marker [location.latitude, location.longitude], 
			title: location.address				
			riseOnHover: true
			icon: L.icon iconUrl: '/assets/leaflet/marker-icon.png'									

		marker.on 'mouseover', ->	
			$('#results').animate scrollTop: $('#results').scrollTop() + $("#location-#{location.id}").position().top - 50, 1000
			$scope.$apply => 												
				$scope.activeLocation = location				
				$timeout => @bindPopup($('#topic-popup').html())
				$timeout => @openPopup()				

		location.marker = marker

		marker

	$scope.locateMarker = (location)->		
		map.setView location.marker.getLatLng(), 15, 
			animate: true, 
			pan: 	
				duration: 1
				easeLinearity: 1
		$scope.activeLocation = location
		setTimeout ->
			location.marker.bindPopup($('#topic-popup').html())
			location.marker.openPopup()				
		, 1500

	$scope.toggleTopics = -> 		
 		for location in $scope.locations 		
 			if $scope.showTopics	
 				location.marker.setOpacity 1
 				$scope.cluster.addLayer location.marker
 			else
 				location.marker.setOpacity 0
 				$scope.cluster.removeLayer location.marker

 	@loadPeople = =>
    for person in $scope.people
      map.removeLayer person.marker
    
    return false unless $scope.showPeople

    params = 
      n: map.getBounds().getNorth()
      s: map.getBounds().getSouth()
      e: map.getBounds().getEast()
      w: map.getBounds().getWest()
      z: map.getZoom()
    
    $http.get("/v2/people.json", params: params).success (people)=>
      $scope.people = people
      for person in people
        @personMarker(person)

 	$scope.togglePeople = =>
    if $scope.showPeople      
      @loadPeople()
    else
      for person in $scope.people
	      map.removeLayer person.marker

	$http.get("/v2/topics.json").success (locations)=>
		$scope.locations = locations		
		$scope.cluster = new L.MarkerClusterGroup()		
		for location in locations		
			$scope.cluster.addLayer @prepareMarker(location)

		map.addLayer $scope.cluster

	@personMarker = (p)->
    if map.getZoom() < 16
      marker = L.circleMarker [p.latitude, p.longitude], radius: if p.count < 20 then 20 else p.count/10
    else
      marker = L.marker [p.latitude, p.longitude], 
        title: p.address       
        riseOnHover: true
        icon: L.icon iconUrl: '/assets/leaflet/marker-icon.png'

      marker.on 'mouseover', ->
        html = []
        for per in p.people
          html.push "<a href=\"#{per.url}\" target=\"_blank\">#{per.name}</a>" 
        @bindPopup html.join('<br>')
        @openPopup()
    p.marker = marker
    marker.addTo map		

	map.on 'zoomend', @loadPeople
	map.on 'dragend', @loadPeople
	$timeout @loadPeople
]