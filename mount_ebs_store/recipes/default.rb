mount_point = node['ebs']['raids']['/dev/md0']['mount_point'] rescue nil

if mount_point
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
end