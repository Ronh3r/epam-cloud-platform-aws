# Terraform Lambda SQS Project

This project sets up an AWS infrastructure (with Localstack) using Terraform, which includes:
- API Gateway
- Two Lambda functions (Producer and Consumer)
- SQS queue with a Dead Letter Queue (DLQ)
- DynamoDB table
- CloudWatch log groups

The Producer Lambda validates incoming data and sends it to the SQS queue, while the Consumer Lambda processes messages from the SQS queue and stores the information in DynamoDB.

## Project Structure

```
epam-cloud-platform-aws
├── lambdas                   # Lambda function code
├── modules
│   ├── api_gateway           # API Gateway configuration
│   ├── cloudwatch            # CloudWatch log groups
│   ├── dynamodb              # DynamoDB table configuration
│   ├── lambda                # Lambda functions configuration
│   └── sqs                   # SQS queue configuration
├── scripts                   # Helper scripts
├── docker-compose.yaml       # Docker Compose for localstack
├── example.env               # Example variable values for localstack
├── main.tf                   # Root Terraform configuration
├── providers.tf              # Provider configurations
├── variables.tf              # Root module variables
├── outputs.tf                # Root module outputs
├── versions.tf               # Terraform and provider versions
├── terraform.tfvars.example  # Example variable values
├── .gitignore                # Git ignore file
└── README.md                 # Project documentation
```

## Prerequisites

1. **Install Terraform**: Ensure you have Terraform installed on your machine. You can download it from [terraform.io](https://www.terraform.io/downloads.html).

2. **(Optional) Install localstack**: Ensure you have Terraform installed on your machine. You can download it from [localstack.cloud](https://docs.localstack.cloud/aws/getting-started/installation/).

## Setup Instructions

1. **Clone the Repository**: Clone this repository to your local machine.

2. **Configure AWS Credentials and Environment Variables**: Set up your AWS credentials using the .env file (Example: [_example.env_](example.env)). You can run the following command:
   ```
   source .env
   ```

3. **(Optional) Start the localstack app with Docker Compose**: Run the following command
   ```
   docker compose -d
   ```

4. **Initialize Terraform**: Run the following command to initialize the Terraform configuration:
**Note**: If you're using an aws account comment the _provider["aws"].endpoints_ code in [_providers.tf_](providers.tf)  file
   ```
   terraform init
   ```

5. **Review the Plan**: Check what resources will be created by running:
   ```
   terraform plan
   ```

6. **Apply the Configuration**: Deploy the infrastructure by executing:
   ```
   terraform apply
   ```

7. **Test the Lambda Functions**: With the API_URL_ENDPOINT output, use the script `scripts/test-apigateway.sh` to test the Producer Lambda function.

## Usage

- The **Producer Lambda** function can be triggered via the API Gateway endpoint created in the `api_gateway` module. It validates incoming JSON data and sends it to the SQS queue.
- The **Consumer Lambda** function processes messages from the SQS queue and stores the relevant information in the DynamoDB table.

## Cleanup

To remove all resources created by Terraform, run:

```
terraform destroy
```

## Good to know

If you're using localstack, you can check the lambda response code in the logs of the localstack-main container 
```
docker logs -f localstack-main
```

In localstack you also can check the dynamodb itemCount with the command:
```
aws dynamodb describe-table \
   --table-name <DYNAMODB_TABLE_NAME> \
   --query 'Table.ItemCount' \
   --endpoint http://localhost:4566
```
