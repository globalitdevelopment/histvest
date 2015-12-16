class CensusSearchWorker
  include Sidekiq::Worker

  def perform name
    firstname, lastname = Person.parse_name name
    Person.search fornavn: firstname
    Person.search etternavn: lastname
    Person.search fornavn: firstname, etternavn: lastname
    Person.search etternavn: firstname, fornavn: lastname
  end

end
