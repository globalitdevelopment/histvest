# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

ReferenceType.create!([
	{ name: "Avis", typestrings: ['newspaper', 'paper'] },				# Newspaper
	{ name: "Foto", 													# Photo
	  typestrings: ['photo', 
	  				'image', 
	  				'stillimage', 
	  				'foto', 
	  				'tegning', 
	  				'fotoserie',
	  				'tegningserie',
	  				'kartserie'] 
	},
	{ name: "Plakat", typestrings: ['poster'] },						# Poster
	{ name: "Bok", typestrings: ['book', 'bøker', 'books'] },			# Book
	{ name: "Film", typestrings: ['movie', 'film'] },					# Movie/Film
	{ name: "Musikk", typestrings: ['music'] },							# Music
	{ name: "Radio", typestrings: ['radio'] },							# Radio
	{ name: "Lydopptak", typestrings: ['recording', 'lyd'] },			# Audio Recording
	{ name: "Musikkmanuskript", typestrings: [] },						# Music Manuscript
	{ name: "Privatarkiv", typestrings: [] },							# Private Archive
	{ name: "Kart", typestrings: ['map', 'kart'] },						# Map
	{ name: "Noter", typestrings: ['note'] },							# Notes
	{ name: "Tidskrift", typestrings: ['journal'] },					# Journal
	{ name: "Artikkel", typestrings: ['article'] },
	{ name: "Person", typestrings: ['person']},
	{ name: "Ukjent" }
])

ReferenceSource.create!([
	{ name: "Nasjonalbiblioteket" },
	{ name: "Wikipedia" },
	{ name: "Europeana" },
	{ name: "Digitalarkivet" }
])

user = User.new(
	{ name: "Admin", email: "admin@example.com", password: "hemmelig", password_confirmation: "hemmelig", role: 'admin'}
)
user.status = true
user.save!

Topic.create!([
	{ title: "Svend Foyn", content: "This is a sample topic.", published: true, user_id: 1 }
])

Article.create!([
	{ title: "Sample Article", content: "This is a sample article.", published: true, user_id: 1 }
])

Location.create!([
	{ address: "Svend Foyns gate, Tonsberg, Norge"},
	{ address: "Grevinneveien, Tonsberg, Norge"}
])