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
    spex_items = Spex.find(:all, :conditions => ['year = ? AND is_revival = ? AND spex_category_id = ?', File.basename(poster, File.extname(poster)), false, spex_category.id])
    spex_items.each do |spex|
      puts "  Uploading poster for spex (year: #{spex.year}, title: #{spex.title})"
      uploaded_poster = ActionController::TestUploadedFile.new(File.new(poster).path, "image/#{File.extname(poster).nibble(1)}", true)
      spex.poster = uploaded_poster
      if spex.save
        puts '    Successfully uploaded'
      else
        puts "    Upload failed due to '#{spex.errors.on(:poster)}'"
      end
      spex_revival_items = Spex.find(:all, :conditions => ['title = ? AND is_revival = ? AND spex_category_id = ?', spex.title, true, spex_category.id])
      spex_revival_items.each do |spex_revival|
        puts "    Uploading poster for spex revival (year: #{spex_revival.year})"
        spex_revival.poster = uploaded_poster
        if spex_revival.save
          puts '      Successfully uploaded'
        else
          puts "      Upload failed due to '#{spex.errors.on(:poster)}'"
        end
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
end
