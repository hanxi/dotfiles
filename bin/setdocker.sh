sudo docker ps # which works fine
docker ps # which doesn't work because of permission failure
sudo addgroup --system docker
sudo adduser $USER docker
newgrp docker
sudo snap restart docker
sudo service docker restart
sudo chmod 666 /var/run/docker.sock
docker ps # this now works because my user is in the group
