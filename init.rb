cingel_admin_root = "vendor/plugins/cingel_admin"
cingel_admin_images_path = "public/images/cingel_admin"
cingel_admin_javascripts_path = "public/javascripts/cingel_admin"

system("cd #{Rails.root}/public/images; ln -s ../../#{cingel_admin_root}/#{cingel_admin_images_path} cingel_admin") unless File.exist?("#{Rails.root}/#{cingel_admin_images_path}")
system("cd #{Rails.root}/public/javascripts; ln -s ../../#{cingel_admin_root}/#{cingel_admin_javascripts_path} cingel_admin") unless File.exist?("#{Rails.root}/#{cingel_admin_javascripts_path}")
Sass::Plugin.add_template_location("#{Rails.root}/#{cingel_admin_root}/public/stylesheets/sass/cingel_admin", "#{Rails.root}/public/stylesheets/cingel_admin")