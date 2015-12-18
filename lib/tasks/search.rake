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
    Topic.published.includes(:locations, :references, :avatar).import
    Topic.where.not(id: Topic.published.ids).each do |topic| 
      begin
        topic.__elasticsearch__.delete_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
      end
    end

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
    Location.joins(:people).includes(:people).import
    Topic.published.includes(:locations, :references, :avatar).import
    Topic.where.not(id: Topic.published.ids).each do |topic| 
      begin
        topic.__elasticsearch__.delete_document
      rescue Elasticsearch::Transport::Transport::Errors::NotFound
      end
    end
  end

end