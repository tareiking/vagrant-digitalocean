# if ! vagrant box list | grep chassis_digitalocean 1>/dev/null; then
#     vagrant box add chassis_digitalocean box/chassis_digitalocean.box
# fi

cd test

vagrant up --provider=chassis_digitalocean
vagrant up
vagrant provision
vagrant rebuild
vagrant halt
vagrant destroy

cd ..
