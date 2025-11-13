module "dynamodb" {
  source              = "./modules/dynamodb"
  dynamo_project_name = var.main_project_name
}

module "sqs" {
  source           = "./modules/sqs"
  sqs_project_name = var.main_project_name
}

module "lamba" {
  source              = "./modules/lambda"
  lambda_project_name = var.main_project_name
  sqs_queue_id        = module.sqs.sqs_queue_id
  sqs_queue_arn       = module.sqs.sqs_queue_arn
  dynamodb_name       = module.dynamodb.dynamodb_table_name
  dynamodb_arn        = module.dynamodb.dynamodb_table_arn
}

module "api_gateway" {
  source                        = "./modules/api_gateway"
  api_gateway_environment       = var.environment
  api_gateway_project_name      = var.main_project_name
  producer_lambda_arn           = module.lamba.producer_lambda_arn
  producer_lambda_invoke_arn    = module.lamba.producer_lambda_invoke_arn
  producer_lambda_function_name = module.lamba.producer_lambda_function_name
}

module "cloudwatch" {
  source               = "./modules/cloudwatch"
  consumer_lambda_name = module.lamba.consumer_lambda_function_name
  producer_lambda_name = module.lamba.producer_lambda_function_name
}
