# SQS Queue, S3 Bucket, and NGINX K8s installation using Helm
This Terraform module deploys an AWS SQS Queue, an AWS S3 Bucket, and a NGINX Helm Chart into a specified Kubernetes cluster.

---
# Using the Bitbucket pipeline
1. Setup OIDC for the target AWS Account- check [Deploy on AWS using Bitbucket Pipelines OpenID Connect](https://support.atlassian.com/bitbucket-cloud/docs/deploy-on-aws-using-bitbucket-pipelines-openid-connect/) for reference.
2. Setup the `AWS_REGION` and `AWS_ROLE` Repository variables - check [Variables and secrets](https://support.atlassian.com/bitbucket-cloud/docs/variables-and-secrets/) for reference.
3. Setup the `awscli` cache- check [Caches](https://support.atlassian.com/bitbucket-cloud/docs/cache-dependencies/) for reference.

---
# Using the Terraform module
## Deploying all resources
1. In `main.tf`, provide local variables with the appropriate values.
2. In `main.tf`, provide appropriate values for properties from each module.
3. From the root module, run `terraform apply`.

## Deploying the Amazon SQS Queue
1. In `main.tf`, provide appropriate values for the `sqs` module's properties.
```hlc
module "sqs" {
    source = "./aws-sqs"
    # Using variable defaults
}
```

2. From the root module, run `terraform apply -target=module.sqs` to deploy the AWS SQS Queue.

### Input variables
These variables must be provided inside the `module "sqs"` block in `main.tf`.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `queue_name` | The name of the queue. Must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long. | `string` | `""` | <span style="color: green">Optional</span> |
| `message_visibility_timeout` | The amount of time messages in the queue are visible for, specified in seconds. Must range from 0 to 43200 (12 hours). | `number` | `30` | <span style="color: green">Optional</span> |
| `message_retention_period` | The amount of time the queue retains messages for, specified in seconds. Must range from 60 (1 minute) to 1209600 (14 days). | `number` | `345600` | <span style="color: green">Optional</span> |
| `message_size_max` | The size limit for messages accepted by the queue, specified in bytes. Must range from 1024 (1 KiB) to 262144 (256 KiB). | `number` | `262144` | <span style="color: green">Optional</span> |
| `message_delay` | The amount of time to delay messages in the queue for, specified in seconds. Must range from 0 to 900 (15 minutes). | `number` | `0` | <span style="color: green">Optional</span> |
| `message_long_polling` | The amount of time to wait before returning ReceiveMessage calls, specified in seconds. Must range from 0 to 20. | `number` | `0` | <span style="color: green">Optional</span> |
| `permissions_send` | Lists of IAM Users, IAM Roles, and AWS Accounts that can send messages to the queue. | `object({`<br />`users=list(string)`<br />`roles=list(string)`<br />`accounts=list(string)`<br />`})` | `{`<br />`users=[]`<br />`roles=[]`<br />`accounts=[]`<br />`}` | <span style="color: green">Optional</span> |
| `permissions_retrieve` | Lists of IAM Users, IAM Roles, and AWS Accounts that can retrieve messages from the queue. | `object({`<br />`users=list(string)`<br />`roles=list(string)`<br />`accounts=list(string)`<br />`})` | `{`<br />`users=[]`<br />`roles=[]`<br />`accounts=[]`<br />`}` | <span style="color: green">Optional</span> |
| `permissions_manage` | Lists of IAM Users, IAM Roles, and AWS Accounts that can manage the queue. The queue creator receives these permissions by default. | `object({`<br />`users=list(string)`<br />`roles=list(string)`<br />`accounts=list(string)`<br />`})` | `{`<br />`users=[]`<br />`roles=[]`<br />`accounts=[]`<br />`}` | <span style="color: green">Optional</span> |
| `fifo_queue` | Whether to create a FIFO queue and enable content-based deduplication, and the level throughput quota applies to. `content_based_deduplication` and `throughput_limit` are only set if `enabled = true`. `throughput_limit` must be either `"perQueue"` or `"perMessageGroupId"`. | `object({`<br />`enabled=bool`<br />`content_based_deduplication=bool`<br />`throughput_limit=string`<br />`})` | `{`<br />`enabled=false`<br />`content_based_deduplication=true`<br />`throughput_limit="perQueue"`<br />`})` | <span style="color: green">Optional</span> |
| `message_encryption` | Whether to enable server-side encryption for messages in the queue, the key to be used, and the amount of time the key can be cached by the queue. If no `key_id` is provided, a new one is automatically created. `key_cache_period` must range from 60 (1 minute) to 86,400 (24 hours) seconds. | `object({`<br />`enabled=bool`<br />`key_id=string`<br />`key_cache_period=number`<br />`})` | `{`<br />`enabled=true`<br />`key_id=""`<br />`key_cache_period=300`<br />`})` | <span style="color: green">Optional</span> |
| `message_deduplication` | Specifies the level in which message deduplication occurs in the queue. Must be either `"messageGroup"` or `"queue"`. | `string` | `"queue"` | <span style="color: green">Optional</span> |

### Output values
These variables can be passed as input to other modules in `main.tf`.

| Name | Description | Reference |
|------|-------------|-----------|
| `endpoint` | The endpoint of the SQS queue. | `module.sqs.endpoint` |

## Deploying the Amazon S3 Bucket
1. In `main.tf`, provide appropriate values for the `s3` module's properties.
```hlc
module "s3" {
    source = "./aws-s3"
    # Using variable defaults
}
```

2. From the root module, run `terraform apply -target=module.s3` to deploy the AWS S3 Bucket.

### Input variables
These variables must be provided inside the `module "s3"` block in `main.tf`.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `bucket_name` | The name of the bucket. Must be universally unique; contain only lowercase letters, numbers, dots, and hyphens; begin and end with a letter or number; and range from 3 to 63 characters in length. Check other naming rules- [Bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html). | `string` | `""` | <span style="color: green">Optional</span> |
| `object_lock` | Whether to enable write-once-read-many (WORM) in the bucket, the retention mode, and the amount of time for the retention period. mode and days or years are only set if `enabled = true`. Mode must be either `"COMPLIANCE"` or `"GOVERNANCE"`. At least one of the retention period attributes must be greater than 0. If both days and years are specified, years takes precedence. | `object({`<br />`enabled=bool`<br />`mode=string`<br />`days=number`<br />`years=number`<br />`})` | `{`<br />`enabled=false`<br />`mode="GOVERNANCE"`<br />`days=0`<br />`years=3`<br />`}` | <span style="color: green">Optional</span> |
| `logging_bucket` | The ID of a bucket to store server access logs. If no value is provided, server access logs are sent to the same bucket. | `string` | `""` | <span style="color: green">Optional</span> |
| `sysadmin_group` | The URI of the an IAM Group that can read server access log files. | `string` | `""` | <span style="color: green">Optional</span> |
| `cloudfront_distribution` | Whether to allow a CloudFront distribution to serve objects from the bucket, and the corresponding OAI's ID. | `object({`<br />`enabled=bool`<br />`oai=string`<br />`})` | `{`<br />`enabled=false`<br />`oai=""`<br />`}` | <span style="color: green">Optional</span> |

### Output values
These variables can be passed as input to other modules in `main.tf`.

| Name | Description | Reference |
|------|-------------|-----------|
| `endpoint` | The endpoint of the S3 bucket. | `module.s3.endpoint` |

## Deploying the NGINX Helm Chart
1. In `main.tf`, provide local variables with the appropriate values.
```hlc
locals {
    cluster_name = "cluster"
    cluster_ip = "35.187.14.109"
    cluster_endpoint = "https://${var.cluster_ip}:80"
    cluster_ca_certificate = base64decode("certificate.b64")
}
```

2. In `main.tf`, provide appropriate values for the `nginx` module's properties.
```hlc
module "nginx" {
    source = "./nginx"

    cluster_ip = local.cluster_ip
    sqs_endpoint = module.sqs.endpoint
    s3_endpoint = module.s3.endpoint
}
```

3. From the root module, run `terraform apply -target=module.nginx` to deploy the NGINX Helm Chart.

### Local variables
These variables must be provided inside the `locals` block in `main.tf`.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `cluster_name ` | The name of the Kubernetes cluster to deploy the NGINX Helm Chart to. | `string` | N/A | <span style="color: red">Required</span> |
| `cluster_ip ` | The IP of the Kubernetes cluster to deploy the NGINX Helm Chart to. | `string` | N/A | <span style="color: red">Required</span> |
| `cluster_endpoint` | The endpoint of the Kubernetes cluster to deploy the NGINX Helm Chart to. | `string` | N/A | <span style="color: red">Required</span> |
| `cluster_ca_certificate` | The base64 encoded CA Certificate of the Kubernetes cluster to deploy the NGINX Helm Chart to. | `string` | N/A | <span style="color: red">Required</span> |

### Input variables
These variables must be provided inside the `module "nginx"` block in `main.tf`.

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `cluster_ip` | The IP address of the Kubernetes master. | `string` | N/A | <span style="color: red">Required</span> |
| `sqs_endpoint` | The endpoint of the SQS Queue. | `string` | N/A/ | <span style="color: red">Required</span> |
| `s3_endpoint` | The endpoint of the S3 Queue. | `string` | N/A/ | <span style="color: red">Required</span> |