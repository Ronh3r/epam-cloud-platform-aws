# 1. Creación del API Gateway REST
resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "${var.api_gateway_project_name}-BookAPI"
  description = "API para recibir datos de libros y enviarlos a SQS."
}

# 2. Creación del Recurso (/book)
resource "aws_api_gateway_resource" "book_resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "book" # El endpoint será /book
}

# 3. HttpMethod POST
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  resource_id   = aws_api_gateway_resource.book_resource.id
  http_method   = "POST"
  authorization = "NONE" # No requiere autorización para simplificar
  # Se espera el Content-Type application/json
  request_models = {
    "application/json" = "Error" # Usar 'Error' como modelo de paso (sin validación)
  }
}

# 4. Integración del Método POST con la Lambda Producer
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.book_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY" # Usar integración AWS_PROXY (Lambda Proxy)
  uri                     = var.producer_lambda_invoke_arn

  passthrough_behavior = "WHEN_NO_MATCH"
}

# 5. Permiso para que API Gateway invoque la Lambda
resource "aws_lambda_permission" "apigw_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.producer_lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # Este ARN limita el permiso a este API Gateway específico
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}

# 6. Despliegue (Deployment) del API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  lifecycle {
    create_before_destroy = true # Crea un nuevo despliegue antes de destruir el viejo
  }
}

resource "aws_api_gateway_stage" "stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  stage_name    = var.api_gateway_environment
}