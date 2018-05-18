# recipe: MongoDB
# installs 64 bit mongodb, ignores 32 bit

# 64 bit mongo repo
yum_repository 'mondoDB_repo' do
  description 'MongoDB Repository'
  baseurl 'http://downloads-distro.mongodb.org/repo/redhat/os/x86_64/'
  gpgcheck false
end

# If you are running a 32-bit system, which is not recommended for production deployments, use the following configuration:
# [mongodb]
# name=MongoDB Repository
# baseurl=http://downloads-distro.mongodb.org/repo/redhat/os/i686/
# gpgcheck=0
# enabled=1

# Install the MongoDB packages and associated tools.
package 'mongodb-org'

# Start MongoDB.
service 'mongod' do
  action [:enable, :start]
end

# ensure that MongoDB will start following a system reboot by issuing the following command:
# sudo chkconfig mongod on#
