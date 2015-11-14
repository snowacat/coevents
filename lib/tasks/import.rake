namespace :utils do
  desc "Import country to db."
  task :import_country => :environment do
    data = File.read("public/countriesList.json")
    parsed_json = ActiveSupport::JSON.decode(data)
    parsed_json.each do |record|
      Country.create(country_name: record["name"])
    end

    puts "Data import completed."
  end
end