class AddUnaccentExtension < ActiveRecord::Migration
  def change
    begin
      execute "create extension if not exists unaccent"
    rescue StandardError => e
      puts "Could not create extension unaccent. Please contact with your system administrator: #{e}
    end
  end
end
