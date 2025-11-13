import os
import json
import uuid
import boto3

# Inicializa el cliente SQS fuera del handler para reutilización
# sqs = boto3.client('sqs')
sqs = boto3.client(
    'sqs',
    # region_name=os.environ.get('AWS_DEFAULT_REGION'),
    endpoint_url=os.environ.get('SQS_QUEUE_URL'),
    aws_access_key_id=os.environ.get('AWS_ACCESS_KEY_ID'),
    aws_secret_access_key=os.environ.get('AWS_SECRET_ACCESS_KEY')
)

SQS_QUEUE_URL = os.environ.get('SQS_QUEUE_URL')

def validate_and_process_data(data):
    """Valida y reestructura los datos de entrada."""
    
    # 1. Validar datos requeridos
    if not data or not all(k in data for k in ['title', 'author', 'isbn']):
        # Se podría lanzar una excepción o devolver un error más específico
        raise ValueError("Datos inválidos. Se requiere 'title', 'author' e 'isbn'.")

    # 2. Restructurar / Añadir datos de control
    book_id = str(uuid.uuid4())
    
    validated_data = {
        'bookId': book_id,
        'title': data['title'],
        'author': data['author'],
        'isbn': data['isbn'],
        'timestamp': data.get('timestamp', 'N/A') # Mantener datos opcionales
    }
    
    return validated_data

def handler(event, context):
    try:
        # i. REST API endpoint (recibe JSON)
        # API Gateway usa 'body' como string JSON
        if 'body' in event:
            request_data = json.loads(event['body'])
        else:
            # Manejar llamadas directas a Lambda
            request_data = event

        # ii. Validar datos, reestructurar
        message_data = validate_and_process_data(request_data)

        # iii. Enviar a SQS
        response = sqs.send_message(
            QueueUrl=SQS_QUEUE_URL,
            MessageBody=json.dumps(message_data),
            # Usar bookId como MessageDeduplicationId o MessageGroupId si usas FIFO
            MessageAttributes={
                'BookTitle': {
                    'DataType': 'String',
                    'StringValue': message_data['title']
                }
            }
        )

        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Libro recibido y enviado a SQS',
                'bookId': message_data['bookId'],
                'sqsMessageId': response['MessageId']
            })
        }

    except ValueError as e:
        print(f"Error de validación: {e}")
        return {
            'statusCode': 400,
            'body': json.dumps({'error': str(e)})
        }
    except Exception as e:
        print(f"Error en Producer Lambda: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({'error': 'Error interno del servidor'})
        }
