namespace :misc do

  desc 'Clear cache'
  task cache: :environment do
    Rails.cache.clear
  end

end