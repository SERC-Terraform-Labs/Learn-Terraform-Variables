# Learn Terraform variables

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/.../...)

You can use input variables to customize your Terraform configuration with
values that can be assigned by end users of your configuration. Input variables
allow users to re-use and customize configuration by providing a consistent
interface to change how a given configuration behaves.

Follow along with this [tutorial on HashiCorp
Learn](https://learn.hashicorp.com/tutorials/terraform/variables?in=terraform/configuration-language). **Do not** clone the example repository. The files are already included here.

Add changes to version control as you go through the steps in the tutorial. This will make it easier to see which configuration settings have changed.

**Warning:** Not sure if all the AWS resources provisioned in this tutorial are covered by the free tier (NAT gateway definitely isn't). There may be some small charges. If you leave resources provisioned and don't `terraform destroy` at the end, there definitely will be charges.
