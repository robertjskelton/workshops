# recipe: middleman
# Runs on Ubuntu
# Robert Skelton

# ## Installation Commands
# apt-get update
apt_update

# apt-get install build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3
package %w(build-essential libssl-dev libyaml-dev libreadline-dev openssl curl git-core zlib1g-dev bison libxml2-dev libxslt1-dev libcurl4-openssl-dev nodejs libsqlite3-dev sqlite3)

# # Build Ruby
# mkdir ~/ruby
# cd ~/ruby
# wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz
# tar -xzf ruby-2.1.3.tar.gz
# cd ruby-2.1.3
# ./configure
# make install
# rm -rf ~/ruby
# # Ruby may install to /usr/local/bin
# # So you may need to make copies of the core commands into /usr/bin
# # cp /usr/local/bin/ruby /usr/bin/ruby
# # cp /usr/local/bin/gem /usr/bin/gem


# bash 'build_ruby' do
#   cwd ::File.dirname('/tmp')
#   code <<-EOH
#   mkdir ~/ruby
#   cd ~/ruby
#   wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.3.tar.gz
#   tar -xzf ruby-2.1.3.tar.gz
#   cd ruby-2.1.3
#   ./configure
#   make install
#   rm -rf ~/ruby
#   cp /usr/local/bin/ruby /usr/bin/ruby
#   cp /usr/local/bin/gem /usr/bin/gem
#   EOH
# end



# # Install apache
# apt-get install apache2
package 'apache2'

# # Configure apache
# a2enmod proxy_http
# a2enmod rewrite
# cp blog.conf /etc/apache2/sites-enabled/blog.conf
# rm /etc/apache2/sites-enabled/000-default.conf
bash 'configure_apache' do
  cwd ::File.dirname('/tmp')
  code <<-EOH
  a2enmod proxy_http
  a2enmod rewrite
  rm /etc/apache2/sites-enabled/000-default.conf
  EOH
end

cookbook_file '/etc/apache2/sites-enabled/blog.conf' do
  source 'blog.conf'
  mode '0755'
  action :create
end

#
# # Restart apache
#
# service apache2 restart
service 'apache' do
  action [ :enable, :start ]
end

# # Install Git
# apt-get install git
package 'git'

# # Clone the repo
# git clone https://github.com/learnchef/middleman-blog.git
git '/tmp' do
  repository 'https://github.com/learnchef/middleman-blog.git'
  revision 'master'
  action :sync
end


# cd middleman-blog
# gem install bundler

bash 'install_bundler' do
  cwd ::File.dirname('/tmp/middleman-blog')
  code <<-EOH
  gem install bundler
  EOH
end

#
#
# # Install project dependencies
#
# bundle install
# > should not be run as root. So another should be created
# RJS: I think this meant another user should be created?
user 'robert' do
  comment 'Robert User'
  uid '1234'
  gid '1234'
  home '/home/robert'
  shell '/bin/bash'
  password 'CorrectHorse_BatterySt@pl3'
end

bash 'bundle_install_as_robert' do
  user 'robert'
  cwd ::File.dirname('/tmp/middleman-blog')
  code <<-EOH
  bundle install
  EOH
end

# # Install thin service
# thin install
# /usr/sbin/update-rc.d -f thin defaults

bash 'thin_install' do
  user 'robert'
  cwd ::File.dirname('/tmp/middleman-blog')
  code <<-EOH
  /usr/sbin/update-rc.d -f thin defaults
  EOH
end

# Create a new thin config for the blog and copy into /etc/thin
cookbook_file '/etc/systemd/system/tomcat.service' do
  source 'tomcat.service'
  owner 'robert'
  group 'robert'
  mode '0755'
  action :create
end

# Fix the /etc/init.d/thin script to incude HOME variable
cookbook_file '/etc/init.d/thin' do
  source 'thin'
  owner 'robert'
  group 'robert'
  mode '0755'
  action :create
end

# # Start / Re-start the thin service
# service thin restart
service 'thin' do
  action [ :enable, :start ]
end
