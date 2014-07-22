#= require_self
#= require ./backbone.googlemaps.js
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

Backbone.pubSub = _.extend({}, Backbone.Events)

window.Histvest =
	Models: {}
	Collections: {}
	Routers: {}
	Views: {}

	initialize: ->
		new Histvest.Routers.TopicsRouter
		Backbone.history.start({pushState: true})

	# Given an html id attribute (ex: added-reference-c19),
	# return the client id (c19)
	fetchClientId: (id) ->
		cid = /c\d+$/g.exec(id)

		if cid != null
			return cid[0]
		else
			return null

$(document).ready ->
	Histvest.initialize()
