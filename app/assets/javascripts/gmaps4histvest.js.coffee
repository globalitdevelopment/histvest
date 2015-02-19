Gmaps4HistVest = {}

window.Gmaps4HistVest = Gmaps4HistVest

class @Gmaps4HistVest

    initialize: ->
        @my_mapOptions = {
            zoom: 11,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        @my_map = new google.maps.Map(document.getElementById('map'), @my_mapOptions);
        @visible_infowindow = null
        @bounds_object = new google.maps.LatLngBounds()                
        @topics_clusterer = null     
        @people_clusterer = null   
        @touch_version = false
        @people = []
        @proper_event = if isTouch? and isTouch then 'click' else 'mouseover'        
        
        # action when clicking on marker content
        $(document).on('click', '.infowindow .marker-topic[data-url]', ->            
            window.location = $(this).data('url') unless $('body').hasClass('touch')
        )

        $(document).on('click', '.infowindow .marker-person[data-url]', ->            
            window.open $(this).data('url') unless $('body').hasClass('touch')
        )
        
        google.maps.event.addListener @my_map, 'zoom_changed', @togglePeople

    extend_bounds_with_objects: (objects) ->
        for obj in objects
            @bounds_object.extend(obj.google_marker.position)

    set_center: (lat_lng) ->
        @my_map.setCenter(lat_lng)

    set_zoom: (zoom) ->
        @my_map.setZoom(zoom)

    adjust_to_bounds: ->
        @extend_bounds_with_objects(@markers)       
        @set_center(@bounds_object.getCenter())
        @my_map.fitBounds(@bounds_object)        


    adjust_to_bounds_of_related_locations: ->
        related_locations = []
        for marker in @markers
            related_locations.push marker if marker.belongs_to_current_topic        
        if related_locations.length > 1
            @extend_bounds_with_objects(related_locations)
            @set_center(@bounds_object.getCenter())
            @my_map.fitBounds(@bounds_object)
        else
            @extend_bounds_with_objects(related_locations)
            @set_center(@bounds_object.getCenter())
            @set_zoom(16)

    bind_fancybox: ->
        _this = this;
        $(document).on('click', '.infowindow .marker-topic[data-url]', ->
            $(this).find('.infowindow-readmore').trigger 'click'
        )
        $(".marker-topic .infowindow-readmore").click (e)->                       
            _this.visible_infowindow.close() if _this.visible_infowindow
            e.preventDefault()
            $.fancybox.showActivity()            
            $.fancybox
                'href'            : $(this).attr('href')
                'padding'         : 0,
                'margin'          : 0,
                'width'           : 725,
                'height'          : '90%',
                'scroll'          : 'no',
                'autoScale'       : true,
                'autoDimensions'  : false,
                'transitionIn'    : 'none', 
                'transitionOut'   : 'none',
                'type'            : 'ajax',                
                'onCancel'        : ->
                    $.fancybox.hideActivity()
                'onComplete'      : ->
                    $.fancybox.hideActivity()
                    addthis.toolbox('.addthis_toolbox')
                    addthis.counter(".addthis_counter")
                    DISQUS.reset
                        reload: true                        

    open_infowindow: (current_map, infowindow, marker) ->
        return ->
            current_map.visible_infowindow.close() if current_map.visible_infowindow != null
            infowindow.open(current_map.my_map, marker)
            current_map.bind_fancybox() if current_map.touch_version
            current_map.visible_infowindow = infowindow            

    create_preview_infowindow: (marker, eventtype) ->
        marker.infowindow = new google.maps.InfoWindow({content: marker.description, maxWidth: 320, disableAutoPan: true})
        current_map = this
        google.maps.event.addListener(marker.google_marker, eventtype, @open_infowindow(current_map, marker.infowindow, marker.google_marker))

    create_marker: (marker)->
        return new google.maps.Marker
            position: new google.maps.LatLng(marker.lat, marker.lng)
            map: @my_map
            icon: marker.picture

    create_markers: (eventtype) ->
        for marker, index in @markers
            if not @markers[index].google_marker?
                @markers[index].google_marker = @create_marker marker
                @create_preview_infowindow(@markers[index], eventtype)

    clusterize: ->
        @topics_clusterer.clearMarkers() if @topics_clusterer != null        

        topics_array = new Array                

        for marker in @markers
            marker.google_marker.count = marker.count
            topics_array.push marker.google_marker if marker.type == 'topic'            

        @topics_clusterer = @create_clusterer(topics_array, 'topic')        

    create_clusterer: (markers_array, type) ->       
        clusterer = new MarkerClusterer(@my_map, markers_array, { 
            maxZoom: 15, 
            gridSize: 25
        })
        clusterer.setCalculator (markers, numStyles)->
            index = 0
            title = ""
            count = 0            
            for marker in markers                
                if marker.count
                    count = count + marker.count
                else
                    count++

            dv = count
            while dv != 0
                dv = parseInt(dv/10, 10)
                index++

            index = Math.min index, numStyles
            return text: count, index: index, title: title
        clusterer

    peopleBindings: =>      
      google.maps.event.addListener @my_map, 'zoom_changed', @togglePeople      

    togglerBindings: =>
        $('#show_topics, #show_census').change =>
            @topics_clusterer.setMap if $('#show_topics').is(':checked') then @my_map else null                        
            for marker in @markers
                if marker.type == "topic"
                    marker.google_marker.setMap if $('#show_topics').is(':checked') then @my_map else null                        
                if marker.type == 'person' or marker.type == 'people'
                    marker.google_marker.setMap if $('#show_census').is(':checked') then @my_map else null                        
            true

        $('#show_topics, #show_census').change()



    removeExistingPeople: =>
        # remove existing people marker        
        indexes = []        
        for marker, i in @markers                        
            if marker.type == 'person' or marker.type == 'people'
                marker.google_marker.setMap null
                indexes.push i

        @markers.splice i, 1 for i in indexes        
        
    togglePeople: =>               
        
        # load new from server        
        params = 
            n: @my_map.getBounds().getNorthEast().lat()
            s: @my_map.getBounds().getSouthWest().lat()
            e: @my_map.getBounds().getNorthEast().lng()
            w: @my_map.getBounds().getSouthWest().lng()
            z: @my_map.getZoom()

        $.getJSON "/v2/people.json", params, (res)=>            
            @removeExistingPeople()
            return if @my_map.getZoom() < 12           
            radiusMultiplier = 100
            radiusMultiplier = 50 if @my_map.getZoom() > 12
            radiusMultiplier = 25 if @my_map.getZoom() > 14
            for r in res
                if r['people']
                    google_marker = new google.maps.Marker
                        position: new google.maps.LatLng(r.latitude, r.longitude)
                        map: @my_map
                        icon: if r.people.length > 1 then "http://www.googlemapsmarkers.com/v1/#{r.people.length}/92CD00/" else "http://www.google.com/intl/en_us/mapfiles/ms/micons/green-dot.png"

                    description = $('<div class="infowindow"><h5 class="infowindow-header">'+r.address+'</h5></div>')
                    for p, pi in r.people
                        pel = $('<li class="marker-person"></li>');
                        pel.append('<a class="infowindow-header" href="'+p.url+'" target="_blank">'+p.name+'</a>');
                        pel.appendTo description

                    marker = 
                        type: 'person'
                        google_marker: google_marker
                        description: description.html()

                    @create_preview_infowindow(marker, @proper_event)                    
                else                  
                    google_marker = new google.maps.Circle
                        strokeColor: '#92CD00',
                        strokeOpacity: 0.8,
                        strokeWeight: 2,
                        fillColor: '#2C6700',
                        fillOpacity: 0.35,
                        center: new google.maps.LatLng(r.latitude, r.longitude)
                        map: @my_map
                        radius: Math.sqrt(r.count)*radiusMultiplier
                    marker = 
                        type: 'people'
                        google_marker: google_marker
                @markers.push marker
                    