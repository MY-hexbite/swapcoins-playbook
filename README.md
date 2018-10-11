# Making passwords
```
python -c "from passlib.hash import sha512_crypt; import getpass; print sha512_crypt.encrypt(<insertpasshere>)"
```

# Setup, clone project into source
cd source; git clone git@server:.git swapcoins

# Launch vagrant (in playbook directory)
vagrant up

# Build
ansible-playbook build.yml

# Provision server (first time only). On boot, linode installs on port 22; reassign to whatever is in production_init
ansible-playbook provisioning/provision.yml -i "<ip address>.ca:22," -u root --ask-pass --ask-vault-pass --extra-vars "environment_name=production_init"

# Deploy
ansible-playbook -i environment/production swapcoins.yml --ask-vault-pass

# Init user on remote
sudo node -e 'require("./scripts/make-user.js").init()'
