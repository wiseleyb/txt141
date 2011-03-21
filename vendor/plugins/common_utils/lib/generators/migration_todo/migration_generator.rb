require 'object_mixins'

class MigrationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  argument :migration_name, :type => :string, :default => "#{Time.now.to_migration_time}_new_migration"  
    
  def generate_migration
    template "migration.html.erb", "db/migrate/#{Time.now.to_migration_time}_#{migration_name.underscore}.rb"  
  end
  
end
