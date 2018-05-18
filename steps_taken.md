launch ec2 instance
ssh in
sudo su -
yum install git
mkdir cookbooks
cd cookbooks
git clone https://github.com/robertjskelton/workshops.git
curl -L https://omnitruck.chef.io/install.sh | sudo bash
chef-client -z -o workshops

after everything installed, you can check that tomcat is running at
http://18.206.164.218:8080/ Or your IP
note that port 8080 must be open in your ec2 SG
