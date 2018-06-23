# Vagrant based deployment of the machine using AWS Plugin

This vagrant file help setting up an AWS machine with the pipeline apps installed though the `pipeline-jumpstart-chef` recipe

## Pre Steps
The Vagrantfile checks for following plugins at stratup 
1. vagrant-aws
2. vagrant-env

install the plugins 
```shell
vagrant plugin install vagrant-aws
vagrant plugin install vagrant-env
```

## Setting up .env properties
Copy the `env-sample` file to `.env` and fill up the values for 

1. ACCESS_KEY_ID
2. SECRET_ACCESS_KEY
3. KEYPAIR_NAME _This should exist for your AWS account / IAM user_
4. SECURITY_GROUPS _Name of the securty group to apply to this VM_
5. PRIVATE_KEY_PATH _Path to the key paid .pem file in your local machine_