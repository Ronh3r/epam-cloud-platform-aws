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

2. **Install Docker Compose**: Ensure you have docker and docker compose installed on your machine. You can download it from [docs.docker.com](https://docs.docker.com/compose/install/).

3. **(Optional) Install localstack**: Ensure you have Terraform installed on your machine. You can download it from [docs.localstack.cloud](https://docs.localstack.cloud/aws/getting-started/installation/).

## Setup Instructions

1. **Clone the Repository**: Clone this repository to your local machine.

2. **Configure AWS Credentials and Environment Variables**: Set up your AWS credentials using the .env file (Example: [_example.env_](example.env)). You can run the following command:
   ```bash
   source .env
   ```

3. **(Optional) Start the localstack app with Docker Compose**: Run the following command
   ```bash
   docker compose -d
   ```

4. **Initialize Terraform**: Run the following command to initialize the Terraform configuration:
**Note**: If you're using an aws account comment the _provider["aws"].endpoints_ code in [_providers.tf_](providers.tf)  file
   ```bash
   terraform init
   ```

5. **Review the Plan**: Check what resources will be created by running:
   ```bash
   terraform plan
   ```

6. **Apply the Configuration**: Deploy the infrastructure by executing:
   ```bash
   terraform apply
   ```

7. **Test the Lambda Functions**: With the API_URL_ENDPOINT output, use the script [`test-project.sh`](scripts/test-project.sh) to test the producer and consumer functions.

## Usage

- The **Producer Lambda** function can be triggered via the API Gateway endpoint created in the `api_gateway` module. It validates incoming JSON data and sends it to the SQS queue.
- The **Consumer Lambda** function processes messages from the SQS queue and stores the relevant information in the DynamoDB table.

## Cleanup

To remove all resources created by Terraform, run:
```bash
terraform destroy
```

## Good to know

### How to get logs from LocalStack
If you are using LocalStack, you can check the Lambda response code in the logs of the _localstack-main_ container.
```bash
docker logs -f localstack-main
```
### How to get items from DynamoDB in LocalStack
To get information about your items in DynamoDB from LocalStack, use this command in your terminal:
```bash
aws dynamodb scan \
    --table-name "$DYNAMODB_TABLE_NAME" \
    --endpoint-url http://localhost:4566
```
### How to list of AWS Log Groups in LocalStack
To get information about your AWS Log Groups from LocalStack, use this command in your terminal:
```bash
aws logs describe-log-groups \
   --endpoint-url=http://localhost:4566
```

## Explanation
*   `--endpoint-url=http://localhost:4566`: This part is very important. It tells the AWS CLI to send the command to your LocalStack instance (which usually runs on `http://localhost:4566`) instead of the real AWS Cloud.
