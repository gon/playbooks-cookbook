Chef::Log.info("About to create the `/repos` symlink to the mounted EBS volume")
mount_point = '/mnt/workspace' rescue nil
Chef::Log.info("Mount point is #{mount_point}")

if mount_point
  Chef::Log.info("About to Mount at #{mount_point}")
  node[:deploy].each do |application, deploy|
    unless Dir.exist? "#{mount_point}/repos"
      Chef::Log.info("#{mount_point}/repos does not exist yet")
      directory "#{mount_point}/repos" do
        owner deploy[:user]
        group deploy[:group]
        mode 0770
        action :create
      end
    else
      Chef::Log.info("#{mount_point}/repos already exists")
    end
    
    if Dir.exist?("/srv/www/#{application}/current/repos")
      Chef::Log.info("/srv/www/#{application}/current/repos directory exists, deleting it.")
      Dir.delete("/srv/www/#{application}/current/repos")
    end

    unless File.symlink?("/srv/www/#{application}/current/repos")
      Chef::Log.info("/srv/www/#{application}/current/repos symlink does not exist yet")
      link "/srv/www/#{application}/current/repos" do
        to "#{mount_point}/repos"
      end
    else
      Chef::Log.info("/srv/www/#{application}/current/repos already is a folder or symlink")
    end
  end
else 
  Chef::Log.info("Not mounting as  #{mount_point} is not set")
end
