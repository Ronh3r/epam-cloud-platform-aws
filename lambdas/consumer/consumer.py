import os
import json
import requests
import boto3

# Inicializa los clientes fuera del handler
dynamodb = boto3.resource('dynamodb')
DYNAMODB_TABLE_NAME = os.environ.get('DYNAMODB_TABLE_NAME')
EXTERNAL_BOOK_API = os.environ.get('EXTERNAL_BOOK_API')
table = dynamodb.Table(DYNAMODB_TABLE_NAME)

def get_book_details(title, author):
    """Get additional information from OpenLibrary."""
    
    # Construye la URL para buscar por título y autor en Open Library
    search_title = title.replace(' ', '+').lower()
    search_author = author.replace(' ', '+').lower()
    url = f"{EXTERNAL_BOOK_API}/search.json?title={search_title}&author_name={search_author}"
    print(f"Get info from: {url}")
    
    try:
        response = requests.get(url, timeout=10) 
        response.raise_for_status() # Lanza excepción para códigos de error HTTP
        
        data = response.json()
        
        details = {}
        # Extraer el idioma y el año de publicación del primer resultado encontrado
        if data.get('docs') and data['docs']:
            doc = data['docs'][0]
            if 'language' in doc:
                details['language'] = doc['language'][0]
            if 'first_publish_year' in doc:
                details['first_publish_year'] = doc['first_publish_year']
        
        if not details:
            print(f"Language or publish year not found for '{title}' by '{author}'.")

        return details

    except requests.exceptions.RequestException as e:
        print(f"Error with external API with title '{title}': {e}")
        return {}
    except Exception as e:
        print(f"Uknown error in get_book_details: {e}")
        return {}


def handler(event, context):
    
    # i. Procesa mensajes desde SQS
    for record in event['Records']:
        try:
            # Los mensajes de SQS están en formato JSON dentro del campo 'body'
            message_body = json.loads(record['body'])
            
            title = message_body.get('title')
            author = message_body.get('author')

            if not title or not author:
                print("The SQS message doesn't contains 'title' or 'author'. Skipping register.")
                continue
            
            print(f"Processing the book: '{title}' by '{author}'")

            # ii. Obtener el idioma del libro usando la API externa
            external_details = get_book_details(title, author)
            
            # Combinar datos para almacenar en DynamoDB
            final_book_data = {
                'title': title,
                'author': author,
            }
            
            if 'language' in external_details:
                final_book_data['language'] = external_details['language']
            
            if 'first_publish_year' in external_details:
                final_book_data['first_publish_year'] = external_details['first_publish_year']

            # Si el bookId está presente en el mensaje, lo añadimos
            if 'bookId' in message_body:
                final_book_data['bookId'] = message_body['bookId']
            
            # iii. Almacenar toda la información en DynamoDB
            table.put_item(
               Item=final_book_data
            )
            print(f"Book '{title}' successfully stored in DynamoDB.")
            
        except Exception as e:
            # Si el procesamiento falla, la excepción hará que el mensaje 
            # vuelva a la cola SQS para reintentar.
            print(f"Error processing the message: {e}")
            raise # Re-lanza la excepción para que SQS/Lambda sepa que falló
            
    return {'statusCode': 200, 'body': 'The message has been successfully processed.'}
