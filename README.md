# Learn Terraform variables

You can use input variables to customize your Terraform configuration with
values that can be assigned by end users of your configuration. Input variables
allow users to re-use and customize configuration by providing a consistent
interface to change how a given configuration behaves.

Follow along with this [Learn Terraform variables](https://developer.hashicorp.com/terraform/tutorials/configuration-language/variables) tutorial.

**Do not** clone the example repository. The files are already included here.

Add changes to version control as you go through the steps in the tutorial. This will make it easier to see which configuration settings have changed.

> **Warning:** Not sure if all the AWS resources provisioned in this tutorial are covered by the free tier (NAT gateway definitely isn't). There may be some small charges. If you leave resources provisioned and don't `terraform destroy` at the end, there definitely will be charges.

<details><summary>AWS CLI Credentials</summary>

You will need to add your AWS Access Keys to the AWS CLI client. Configure the AWS CLI from the terminal. Follow the prompts to input your AWS Access Key ID and Secret Access Key.

```bash
$ aws configure
```

The configuration process stores your credentials in a file at `~/.aws/credentials` within the Codespace workspace.

</details>

<details><summary>Mocking AWS - LocalStack</summary>

Instead of applying changes to the real AWS, we can create a fake, local version of AWS and test our configuration against this fake version. This will mean no real resources are provisioned in AWS. To do this, we will use an emulator called [LocalStack](https://github.com/localstack/localstack).

### Starting LocalStack

LocalStack is already installed in the Codespace. To start the LocalStack container, run the following command in the terminal:

```bash
sudo localstack start
```

### Configure Terraform Resource Provider

In `main.tf`, replace the `provider "aws"` block

```terraform
provider "aws" {
  region  = "us-west-2"
}
```

with the following:

```terraform
provider "aws" {
  region                      = "us-west-2"
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  s3_use_path_style           = true

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

Log-in to AWS again, using the fake credentials:

```
access_key: mock_access_key
secret_key: mock_secret_key
```

</details>