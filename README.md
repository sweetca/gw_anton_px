## Ansible and bash scripting to set up node env and redeploy ExampleCenter

#### Server DEV
ssh root@dev-pebbles-refresh
#### Server Board
ssh root@board

#### Vagrant mem:
vagrant init centos/7

vagrant up (switch on)

vagrant ssh

vagrant suspend  (switch of)

vagrant destroy

sudo su -
#### Ansible mem:
ansible-playbook -i '127.0.0.1:2222,' playbook.yml -k

ansible-playbook -i '10.134.14.51:22,' playbook.yml -k