## HistVest

HistVest is a history portal that connects sources from the Norwegian National Library, Europeana and Wikipedia to geographical locations. You can see the project in action at [histvest.no](http://histvest.no).

It is developed by [Global IT Development AS](http://globalit.no) for Tønsberg & Nøtterøy Bibliotek.

## Installation

First copy config/application.yml.example to config/application.yml and edit the variables. Create the database with user and password accordingly. Then all that remains is running "bundle install".

There are no requirements for deployment except that the platform has to support ruby version 2 or later. The server hosting histvest.no currently is on Ubuntu 12.04 LTS, but we recommend that new instances use Ubuntu 14.04 LTS.

## Built With

- [Ruby on Rails](https://github.com/rails/rails)
- [Backbone.js](https://github.com/jashkenas/backbone) &mdash; The more complex forms in the admin panel uses Backbone.
- [PostgreSQL](http://www.postgresql.org/) &mdash; The database used.
- [Gmaps4Rails](https://github.com/apneadiving/Google-Maps-for-Rails) &mdash; Used to power the maps.

As well as a bunch of Ruby Gems, a complete list of which is at [/master/Gemfile](https://github.com/globalitdevelopment/histvest/blob/master/Gemfile).

## Contributing

We encourage you to contribute to the HistVest project! Please create an issue before you submit a pull request.

## License

HistVest is released under the [MIT License](http://www.opensource.org/licenses/MIT).

The data is licensed under NLOD and is available by request to torstein@globalit.no.


