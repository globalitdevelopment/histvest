namespace :search do 

  desc 'Reset mapping and import data'
  task :reset => :environment do

    # reset people
    Person.__elasticsearch__.create_index! force: true
    sleep 1
    Person.__elasticsearch__.refresh_index!
    sleep 1
    Person.includes(:location).import

    # reset topics
    Topic.__elasticsearch__.create_index! force: true
    sleep 1
    Topic.__elasticsearch__.refresh_index!
    sleep 1
    Topic.includes(:locations, :references).import

    # reset locations
    Location.__elasticsearch__.create_index! force: true
    sleep 1
    Location.__elasticsearch__.refresh_index!
    sleep 1
    Location.joins(:people).includes(:people).import

  end

  desc 'Just index documents'
  task :index => :environment do
    Person.includes(:location).import
    Topic.includes(:locations, :references).import
    Location.joins(:people).includes(:people).import
  end

end