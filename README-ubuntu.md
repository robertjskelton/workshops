* launch a ubuntu ec2 instance with the chef SG

* ssh in (local instructions for Macbook Air)
  * cd ~/Downloads/SSH
  * ssh ubuntu@54.164.246.151 -i MyEc2KeyPair.pem

* sudo su -

* mkdir ~/cookbooks

* cd ~/cookbooks

* git clone https://github.com/robertjskelton/workshops.git

* curl -L https://omnitruck.chef.io/install.sh | sudo bash

* apt-get update

* chef-client -z -o recipe[workshops::aar]


* note that port 8080 must be open in your ec2 SG to view the status page
