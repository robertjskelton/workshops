# Recipe:: aar

# The following script assumes that apache2, mysql, and unzip have been installed.
package 'apache2'
package 'mysql-server'
package 'unzip'

# 1. wget https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip
remote_file '/tmp/master.zip' do
  source 'https://github.com/colincam/Awesome-Appliance-Repair/archive/master.zip'
  mode '0755'
  action :create
end

# 2. unzip master.zip
# 3. cd into Awesome-Appliance-Repair
# 4. sudo mv AAR to /var/www/
execute 'extract_aar_zip' do
  command 'unzip /tmp/master.zip'
  cwd '/var/www/'
end

# 5. sudo su root
# 6. run script: python AARinstall.py
cookbook_file '/tmp/AARinstall.py' do
  source 'AARinstall.py'
  mode '0755'
  action :create
end

bash 'run_AAR_install' do
  cwd ::File.dirname('/tmp')
  code <<-EOH
      python /tmp/AARinstall.py
    EOH
end

# 7. manually execute: apachectl graceful
bash 'apachectl' do
  cwd ::File.dirname('/tmp')
  code <<-EOH
      apachectl graceful
    EOH
end
