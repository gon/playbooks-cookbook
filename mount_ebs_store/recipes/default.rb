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

    repos_symlink_path = "/srv/www/#{application}/current/repos"
    if File.symlink? repos_symlink_path
      Chef::Log.info("#{repos_symlink_path} already is a symlink")
    else
      if Dir.exist? repos_symlink_path
        Chef::Log.info("/srv/www/#{application}/current/repos is not a symlink but a directory, deleting it.")
        Dir.delete("/srv/www/#{application}/current/repos")
      end
      Chef::Log.info("#{repos_symlink_path} symlink does not exist yet")
      link repos_symlink_path do
        to "#{mount_point}/repos"
      end
    end
  end
else 
  Chef::Log.info("Not mounting as  #{mount_point} is not set")
end
