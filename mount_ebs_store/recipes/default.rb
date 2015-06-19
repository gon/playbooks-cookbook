Chef::Log.info("About to create the `/repos` symlink to the mounted EBS volume")
mount_point = node['ebs']['raids']['/dev/xvdi']['mount_point'] rescue nil
Chef::Log.info("Mount point is #{mount_point}")

if mount_point
  Chef::Log.info("About to Mount at #{mount_point}")
  node[:deploy].each do |application, deploy|
    unless Dir.exist? "#{mount_point}/repos"
      directory "#{mount_point}/repos" do
        owner deploy[:user]
        group deploy[:group]
        mode 0770
        action :create
      end
    end

    link "/srv/www/#{application}/current/repos" do
      to "#{mount_point}/repos"
    end
  end
else 
  Chef::Log.info("Not mounting as  #{mount_point} is not set")
end
