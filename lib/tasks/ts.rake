namespace :ts do
  namespace :generate do
    desc 'generate typescript models'
    task models: :environment do
      Typescript::Models::Generator.generate
    end

    desc 'generate typescript routes'
    task routes: :environment do
      Typescript::Routes::Generator.generate
    end
  end

  # auto-generate model types after migrations
  ['db:migrate', 'db:rollback'].collect do |task_name|
    Rake::Task[task_name].enhance do
      puts 'Auto-generating Typescript Model Definitions'
      Rake::Task['ts:generate:models'].execute
    end
  end
end
