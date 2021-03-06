# recipe: tomcat

# Install OpenJDK 7 JDK
package 'java-1.7.0-openjdk-devel'

# tomcat user
user 'tomcat' do
  comment 'tomcat user'
  home '/opt/tomcat'
end

# tomcat group
group 'tomcat' do
  action :modify
  members 'tomcat'
end

# download tomcat from source
remote_file '/tmp/apache-tomcat-8.5.20.tar.gz' do
  source 'https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.52/bin/apache-tomcat-8.0.52.tar.gz'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end

# create tomcat home directory
directory '/opt/tomcat' do
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end

# extract tar to /opt/tomcat. could import tar cookbook but didn't.
execute 'extract_tomcat_tar' do
  command 'tar xvf /tmp/apache-tomcat-8.5.20.tar.gz -C /opt/tomcat --strip-components=1'
  cwd '/opt/tomcat/'
end

# update permissions, running this in bash because lots of commands
bash 'update_permissions' do
  cwd ::File.dirname('/tmp')
  code <<-EOH
      sudo chgrp -R tomcat /opt/tomcat
      sudo chmod -R g+r /opt/tomcat/conf
      sudo chmod g+x /opt/tomcat/conf
      sudo chown -R tomcat /opt/tomcat/webapps/ /opt/tomcat/work/ /opt/tomcat/temp/ /opt/tomcat/logs/
    EOH
end

# move files/tomcat.service into place
cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
  owner 'tomcat'
  group 'tomcat'
  mode '0755'
  action :create
end

# Reload Systemd to load the Tomcat Unit file, also doing this in bash
bash 'reload_tomcat' do
  cwd ::File.dirname('/tmp')
  code <<-EOH
      systemctl daemon-reload
    EOH
end

# Ensure `tomcat` is started and enabled
service 'tomcat' do
  action [:enable, :start]
end
