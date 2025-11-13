import os
import json
from botocore.vendored import requests
import boto3

# Inicializa los clientes fuera del handler
dynamodb = boto3.resource('dynamodb')
DYNAMODB_TABLE_NAME = os.environ.get('DYNAMODB_TABLE_NAME')
EXTERNAL_BOOK_API = os.environ.get('EXTERNAL_BOOK_API')
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

def get_book_details(isbn):
    """Obtiene información adicional del libro usando una API externa (Open Library)."""
    
    # Ejemplo de API gratuita de libros que usa el ISBN
    url = f"{EXTERNAL_BOOK_API}/isbn/{isbn}.json"
    
    try:
        # Se requiere 'requests' en el requirements.txt
        response = requests.get(url, timeout=5) 
        response.raise_for_status() # Lanza excepción para códigos de error HTTP
        
        details = response.json()
        
        # Extraer campos de interés
        return {
            'publish_date': details.get('publish_date'),
            'number_of_pages': details.get('number_of_pages'),
            'cover_id': details.get('covers', [None])[0]
        }
    except requests.exceptions.RequestException as e:
        print(f"Error al consultar la API externa para ISBN {isbn}: {e}")
        return {}
    except Exception as e:
        print(f"Error desconocido en get_book_details: {e}")
        return {}


def handler(event, context):
    
    # i. Procesa mensajes desde SQS
    for record in event['Records']:
        try:
            # Los mensajes de SQS están en formato JSON dentro del campo 'body'
            message_body = json.loads(record['body'])
            
            book_id = message_body['bookId']
            isbn = message_body['isbn']
            
            print(f"Procesando libro: {book_id} (ISBN: {isbn})")

            # ii. Obtener más información del libro usando una API externa
            external_details = get_book_details(isbn)
            
            # Combinar datos iniciales y datos externos
            final_book_data = {
                'bookId': book_id,
                'title': message_body.get('title'),
                'author': message_body.get('author'),
                'isbn': isbn,
                'source': 'API Gateway',
                **external_details # Añade los detalles de la API externa
            }
            
            # iii. Almacenar toda la información en DynamoDB
            table.put_item(
               Item=final_book_data
            )
            print(f"Libro {book_id} almacenado exitosamente en DynamoDB.")
            
        except Exception as e:
            # Si el procesamiento falla (ej: API externa, DynamoDB),
            # la excepción hará que el mensaje vuelva a la cola SQS
            # para reintentar (según la configuración de SQS/Lambda)
            print(f"Error al procesar el mensaje: {e}")
            raise # Re-lanza la excepción para que SQS/Lambda sepa que falló el procesamiento
            
    return {'statusCode': 200, 'body': 'Procesamiento de mensajes completado.'}
