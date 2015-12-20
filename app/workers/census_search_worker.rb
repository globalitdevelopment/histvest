class CensusSearchWorker
  include Sidekiq::Worker

  def perform name
    firstname, lastname = Person.parse_name name
    Person.lookup fornavn: firstname
    Person.lookup etternavn: lastname
    Person.lookup fornavn: firstname, etternavn: lastname
    Person.lookup etternavn: firstname, fornavn: lastname
  end

end
