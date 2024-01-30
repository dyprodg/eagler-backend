import boto3
from PIL import Image
from io import BytesIO
import os

s3_client = boto3.client('s3')

def resize_and_crop(image, target_width, target_height):
    # Berechnen des Seitenverhältnisses des Zielbildes
    target_ratio = target_width / target_height

    # Berechnen des Seitenverhältnisses des Originalbildes
    original_width, original_height = image.size
    original_ratio = original_width / original_height

    # Bestimmen, ob das Bild auf Breite oder Höhe skaliert werden soll
    if target_ratio > original_ratio:
        # Bild wird auf die Zielbreite skaliert
        scaled_width = target_width
        scaled_height = round(target_width / original_ratio)
    else:
        # Bild wird auf die Zielhöhe skaliert
        scaled_height = target_height
        scaled_width = round(target_height * original_ratio)

    # Skalieren des Bildes
    image = image.resize((scaled_width, scaled_height), Image.ANTIALIAS)

    # Zentrieren und Ausschneiden des Bildes
    left = (scaled_width - target_width) / 2
    top = (scaled_height - target_height) / 2
    right = (scaled_width + target_width) / 2
    bottom = (scaled_height + target_height) / 2

    image = image.crop((left, top, right, bottom))
    return image

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Load the image from the S3 bucket
    file = s3_client.get_object(Bucket=source_bucket, Key=key)
    file_content = file['Body'].read()

    # Image processing: Crop and compress
    image = Image.open(BytesIO(file_content))
    image = resize_and_crop(image, 1080, 1080)  # Zuschneiden und Skalieren

    # Konvertieren Sie das Bild in RGB, falls es RGBA ist
    if image.mode == 'RGBA':
        image = image.convert('RGB')

    # Save the processed image temporarily
    buffer = BytesIO()
    image.save(buffer, 'JPEG')  # Speichere alle Bilder als JPEG
    buffer.seek(0)

    # Determine the filename for the target bucket
    target_key = os.path.splitext(key)[0] + '.jpeg'

    # Upload the processed image to the target bucket
    target_bucket = os.environ.get('TARGET_BUCKET')  # Read the target bucket from the environment variable
    s3_client.put_object(Bucket=target_bucket, Key=target_key, Body=buffer)

    # Delete the original image
    s3_client.delete_object(Bucket=source_bucket, Key=key)

    return {
        'statusCode': 200,
        'body': 'Image successfully processed and transferred.'
    }
