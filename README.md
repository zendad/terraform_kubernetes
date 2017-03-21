# Basic AWS Architecture

This provides a template for creating multiple ec2 instances with
 terraform and provision docker kubernetes on the instances using ansible.

This will create a new EC2 Key Pair in the specified AWS Region. 
The key name and path to the public key must be specified via the  
terraform command vars.

After you run `terraform apply` on this configuration, it will
automatically output the public ip address of the EC2 instances. After your instance
registers, you can login via ssh.

To run, configure your AWS provider as described in 

https://www.terraform.io/docs/providers/aws/index.html

For example:

```
terraform plan \
  -var 'access_key=foo' \
  -var 'secret_key=bar'
```
