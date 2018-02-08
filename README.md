# galera-cluster

### Purpose

This repo will help you deploy and configure 2 HAProxy nodes with floating IP reassignment and a MariaDB Galera cluster. Provisioning will be handled by Terraform and configuration will be done with Ansible.

### Prerequisites

* You'll need to install [Terraform](https://www.terraform.io/downloads.html) which will be used to handle Droplet provisioning.
* In order to apply configuration changes to the newly provisioned Droplets, [Ansible](http://docs.ansible.com/ansible/intro_installation.html) needs to be installed.
* Ansible's inventory will be handled by Terraform, so you'll need [terraform-inventory](https://github.com/adammck/terraform-inventory).
* We're going to need a DigitalOcean API key. The steps to generate a DigitalOcean API key can be found [here](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-api-v2#how-to-generate-a-personal-access-token).
* Use the included `gen_auth_key` script to generate an auth key for your load balancing cluster.

### Configuration

#### Terraform  

**terraform.tfvars**  

The sample file **terraform.tfvars.sample** has been supplied, just remember to remove the appended _.sample_. Once you have your all of the variables set, Terraform should be able to authenticate and deploy your Droplets.

* do_token - DigitalOcean API key with read/write privileges
* project - Something that easily allows you to distinguish different groups of infrastructure from one another.
* region - Data center location slug.
* image_slug - debian-9-x64 is used by default since this was written to be used with specific Ansible roles.
* keys - Your DigitalOcean ssh key ids. Retrievable using the API.
* private_key_path - Path your private key file. Normally in /home/<username>/.ssh/id_rsa
* ssh_fingerprint - Your ssh key MD5 fingerprint
* public_key - The contents of your ssh public key
* ansible_user - Username you want to use later when configuring Droplets with Ansible.

#### Ansible  

Install the Ansible roles using the requirements.yml file.

    $ ansible-galaxy install -r requirements.yml

The ansible roles require some variables to be set with sensitive data in **group_vars/**. Please refer to their respective README.md files for information on what variables to set.

Quick note! You'll be encrypting the files using ansible vault. Rather than having to type in your vault password every time you run your playbook, I recommend setting up your password in a file outside of your repo.

    $ echo 'password' > ~/.vaultpass.txt

And make sure to uncomment `vault_password_file = ~/.vaultpass.txt` in your ansible.cfg file.

Okay, now everything should be set up and you're ready to start provisioning and configuring your Droplets.

### Deploying

#### Terraform

We'll start by using Terraform. Make sure you head back to the repository root directory. You'll need to run `terraform init` to download the terraform plugins like the digitalocean and template providers. Once that's all set up you can run a quick check and create an execution plan by running `terraform plan`.

Use `terraform apply` to build the Droplets and floating IP. This should take about a minute or two depending on how many nodes you're spinning up.

#### Ansible

Once terraform finishes up, you can check network connectivity using `ansible all -i /usr/local/bin/terraform-inventory -m ping`. That should return *pong* for all nodes.

We're ready to begin configuring the Droplets. Execute the Ansible playbook from the repository root to configure your Droplets by running the following:

    ansible-playbook -i /usr/local/bin/terraform-inventory site.yml

This playbook will install and configure heartbeat, your floating IP re-assignment service, install and configure HAProxy load balancers, and your MariaDB Galera cluster. You should see a steady output which will state the role and step at which Ansible is currently running. If there are any errors, you can easily trace it back to the correct role and task.

License
-------

GPL-3.0

Author Information
------------------
[cmndrsp0ck](https://github.com/cmndrsp0ck)
