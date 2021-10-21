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

## AWS CLI Credentials
You will need to add your AWS Access Keys to the AWS CLI client. Configure the AWS CLI from the terminal. Follow the prompts to input your AWS Access Key ID and Secret Access Key.

```bash
$ aws configure
```

The configuration process stores your credentials in a file at `~/.aws/credentials` within the Gitpod workspace.

## Mocking AWS

Instead of applying changes to the real AWS, we can create a fake, local version of AWS and test our configuration against this fake version. This will mean no real resources are provisioned in AWS.

### Docker

Run the following docker command in the terminal.

```bash
docker run --rm -it -p 4566:4566 -p 4571:4571 localstack/localstack
```

This will pull and run a docker container containing an image that will mock AWS calls for us.

### Configure Resource Provider

In `main.tf`, replace the `provider "aws"` block

```bash
provider "aws" {
  region  = "us-west-2"
}
```

with the following:

```bash
provider "aws" {
  access_key                  = "mock_access_key"
  region                      = "us-east-1"
  s3_force_path_style         = true
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    es             = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    route53        = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    s3             = "http://localhost:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
    ec2            = "http://localhost:4566"
  }
}
```

Log-in to AWS again, using the fake credientials

```
access_key: mock_access_key
secret_key: mock_secret_key
```

After you have run `terraform init` you will need to modify the `aws-instance` module. Open the `modules/aws-instance/main.tf` file. 

- Comment out or remove the `data "aws_ami" "amazon_linux"`.
- Replace the line `ami           = data.aws_ami.amazon_linux.id` with `ami = "ami-830c94e3"`.
