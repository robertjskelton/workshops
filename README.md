* launch a RHEL ec2 instance

* ssh in (local instructions for Macbook Air)
  * cd ~/Downloads/SSH
  * ssh ec2-user@54.164.246.151 -i MyEc2KeyPair.pem

* sudo su -

* yum install -y git

* mkdir ~/cookbooks

* cd ~/cookbooks

* git clone https://github.com/robertjskelton/workshops.git

* curl -L https://omnitruck.chef.io/install.sh | sudo bash

* chef-client -z -o workshops

* after everything installed, you can verify that tomcat is running at http://18.206.164.218:8080/ (replace with your PUBLIC IP, or ELB)

* note that port 8080 must be open in your ec2 SG to view the status page
