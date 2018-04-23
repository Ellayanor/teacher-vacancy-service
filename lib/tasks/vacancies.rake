namespace :vacancies do
  namespace :data do
    desc 'Scrapes vacancies from jobsinschoolsnorthest.com'
    task scrape: :environment do
      Rails.logger.debug("Running vacancies scrape task in #{Rails.env}")
      require 'vacancy_scraper'
      VacancyScraper::NorthEastSchools::Processor.execute!
    end

    desc 'Deletes vacancies specified in lib/tasks/vacancies_to_update.yaml'
    task delete: :environment do
      Rails.logger.debug("Deleting scraped vacancies in #{Rails.env}")
      vacancies = YAML.load_file('./lib/tasks/vacancies_to_update.yaml')['vacancies']['delete']
      vacancies.each do |slug|
        Rails.logger.debug("Deleting vacancy #{slug}")
        vacancy = Vacancy.find_by(slug: slug)
        vacancy.delte
      end
    end

    desc 'Updates vacancies specified in lib/task/vacancies_to_update.yaml'
    task update: :environment  do
      Rails.logger.debug("Editing scraped vacancies in #{Rails.env}")
      vacancies = YAML.load_file('./lib/tasks/vacancies_to_update.yaml')['vacancies']['update']
      vacancies.each do |vacancy_data|
        Rails.logger.debug("Updating vacancy #{vacancy.slug}")
        vacancy = Vacancy.find_by(slug: vacancy_data['slug'])
        vacancy.assign_attributes(vacancy_data)
        vacancy.save(validate: false)
      end
    end
  end
end
