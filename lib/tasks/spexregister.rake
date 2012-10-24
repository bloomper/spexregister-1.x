require 'action_controller'
require 'action_controller/test_process.rb'

class String
  def nibble(fixnum)
    range_end = self.length - 1
    slice(fixnum..range_end)
  end
end

def import_posters(spex_category)
  posters_path = Dir[File.join("#{RAILS_ROOT}", 'test', 'fixtures', 'files', 'posters', "#{spex_category.name.downcase}", '**', '*.{jpg,png,gif}')]
  posters_path.flatten.each do |poster|
    spex_items = Spex.find(:all, :conditions => ['year = ? AND parent_id IS NULL AND spex_category_id = ?', File.basename(poster, File.extname(poster)), spex_category.id])
    spex_items.each do |spex|
      puts "  Uploading poster for spex (year: #{spex.year}, title: #{spex.spex_detail.title})"
      uploaded_poster = ActionController::TestUploadedFile.new(File.new(poster).path, "image/#{File.extname(poster).nibble(1)}", true)
      spex.spex_detail.poster = uploaded_poster
      if spex.save
        puts '    Successfully uploaded'
      else
        puts "    Upload failed due to '#{spex.spex_detail.errors.on(:poster)}'"
      end
    end
  end
end

def import_logos
  logos_path = Dir[File.join("#{RAILS_ROOT}", 'test', 'fixtures', 'files', 'logos', "*.{jpg,png,gif}")]
  logos_path.flatten.each do |logo|
    spex_category = SpexCategory.find(:first, :conditions => ['name = ?', File.basename(logo, File.extname(logo))])
    puts "  Uploading logo for spex category (name: #{spex_category.name})"
    uploaded_logo = ActionController::TestUploadedFile.new(File.new(logo).path, "image/#{File.extname(logo).nibble(1)}", true)
    spex_category.logo = uploaded_logo
    if spex_category.save
      puts '    Successfully uploaded'
    else
      puts "    Upload failed due to '#{spex_category.errors.on(:logo)}'"
    end
  end
end

namespace :spexregister do
  desc 'Import spex posters'
  task :import_posters => :environment do
    SpexCategory.find(:all).each do |spex_category|
      puts "Importing #{spex_category.name} posters..."
      import_posters(spex_category)
    end
  end

  desc 'Import spex category logos'
  task :import_logos => :environment do
    puts "Importing logos..."
    import_logos
  end

  desc "This task will delete sessions (production environment only) that have not been updated in for a configurable amount of days."
  task :clean_sessions => :environment do
    if RAILS_ENV == 'production'
      ActiveRecord::Base.connection.execute("DELETE FROM sessions WHERE updated_at < DATE_SUB(CURDATE(), INTERVAL #{ApplicationConfig.logged_in_timeout} SECOND);")
    else
      puts 'This task is only valid for production environment'
    end
  end

  desc "This task will refresh some cached content to be up to date"
  task :refresh_cached_content => :environment do
    Membership.update_fgv_years
    Membership.update_cing_years
    SpexCategory.update_years
  end

  desc "Reindex all solr models that are located in the application's models directory."
  # This task depends on the standard Rails file naming \
  # conventions, in that the file name matches the defined class name. \
  # By default the indexing system works in batches of 50 records, you can \
  # set your own value for this by using the batch_size argument. You can \
  # also optionally define a list of models to separated by a forward slash '/'
  # 
  # $ rake spexregister:reindex                # reindex all models
  # $ rake spexregister:reindex[1000]          # reindex in batches of 1000
  # $ rake spexregister:reindex[false]         # reindex without batching
  # $ rake spexregister:reindex[,Spexare]      # reindex only the Spexare model
  # $ rake spexregister:reindex[1000,Spexare]  # reindex only the Spexare model in batches of 1000
  # $ rake spexregister:reindex[,Spexare+User]  # reindex Spexare and User model
  task :reindex, :batch_size, :models, :needs => :environment do |t, args|
    puts "Reindexing..."
    reindex_options = {:batch_commit => false}
    case args[:batch_size]
    when 'false'
      reindex_options[:batch_size] = nil
    when /^\d+$/ 
      reindex_options[:batch_size] = args[:batch_size].to_i if args[:batch_size].to_i > 0
    end
    unless args[:models]
      all_files = Dir.glob(Rails.root.join('app', 'models', '*.rb'))
      all_models = all_files.map { |path| File.basename(path, '.rb').camelize.constantize }
      sunspot_models = all_models.select { |m| m < ActiveRecord::Base and m.searchable? }
    else
      sunspot_models = args[:models].split('+').map{|m| m.constantize}
    end
    Sunspot.config.solr.url = Settings['full_text_and_advanced_search.search_engine_url']    
    sunspot_models.each do |model|
      model.reindex reindex_options
    end
  end

end
