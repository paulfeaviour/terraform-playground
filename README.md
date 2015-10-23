terraform-playground
====================
## Overview
This is simple PoC using Terraform to bring up a number of EC2 servers to run Docker with a contrived containerized RESTful API. Nothing particularly original here, just a combination of various tutorials/projects to help me get familiar with these technologies.

## Preparations
Get an AWS account.

Ensure your workstations has Terraform installed.

You can install terraform using **Homebrew** on a Mac using `brew update && brew install terraform`.

Terraform e.g. `brew install terraform`.
See [Terraform Getting Started Guide](https://terraform.io/intro/getting-started/install.html) for more details.

### Extra requirements for AWS provisioning

You need an SSH key to access AWS EC2 instances. 
Use the chmod command to make sure your private key file isn't publicly viewable. For example, if the name of your private key file is my-key-pair.pem, use the following command:

```chmod 400 /path/my-key-pair.pem```

Once Terraform has done it's job you'll be able to use the ssh command to connect to EC2 instances. You'll specify the private key (.pem) file and user_name@public_dns_name. For Amazon Linux, the user name is `ec2-user`. For RHEL5, the user name is either `root` or `ec2-user`. For Ubuntu, the user name is `ubuntu`. For Fedora, the user name is either `fedora` or `ec2-user`. For SUSE Linux, the user name is either `root` or `ec2-user`. Otherwise, if `ec2-user` and `root` don't work, check with your AMI provider.

The terraform provider for AWS will need credentials, these can be read from the following environment variables:

`AWS_ACCESS_KEY_ID`
`AWS_SECRET_ACCESS_KEK`

We will set these as specific variables in `terraform.tfvars`


## Running Terraform
Copy terraform.tfvars.example to terraform.tfvars and set the variables to specific values for your AWS account and applicaiton details, as appropriate.

I am using an Amazon ECS-Optimized Amazon Linux AMI - EC2 charges for Micro instances are free for up to 750 hours a month if you [qualify for the AWS Free Tier](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-free-tier.html)

To check what resources will be created:

```$ terraform plan```

To create EC2 instances and their dependencies:

```$ terraform apply```

To destroy all:

```$ terraform destroy```

_If you run into issues the output can often be a little opaque - well it is when you're starting out. Terraform has detailed logs which can be enabled by setting the `TF_LOG` environmental variable to any value. This will cause detailed logs to appear on stderr.

You can set `TF_LOG` to one of the log levels `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR` to change the verbosity of the logs. `TRACE` is the most verbose and it is the default if `TF_LOG` is set to something other than a log level name_

**Paul Feaviour 2015**
