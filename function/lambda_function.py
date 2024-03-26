import boto3
from PIL import Image
from PIL import ExifTags
from io import BytesIO
import os

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Load the image from the S3 bucket
    file = s3_client.get_object(Bucket=source_bucket, Key=key)
    file_content = file['Body'].read()

    # Image processing: Open and convert to JPEG
    image = Image.open(BytesIO(file_content))

    # Correct the orientation using the exif data
    try:
        for orientation in ExifTags.TAGS.keys():
            if ExifTags.TAGS[orientation] == 'Orientation':
                break
        exif = dict(image._getexif().items())

        if exif[orientation] == 3:
            image = image.rotate(180, expand=True)
        elif exif[orientation] == 6:
            image = image.rotate(270, expand=True)
        elif exif[orientation] == 8:
            image = image.rotate(90, expand=True)
    except (AttributeError, KeyError, IndexError):
        # In case the exif data is not available or doesn't contain orientation info
        pass


    # Konvertieren Sie das Bild in RGB, falls es RGBA oder ein anderes Format ist
    if image.mode != 'RGB':
        image = image.convert('RGB')

    # Compress the image
    buffer = BytesIO()
    image.save(buffer, 'JPEG', quality=85)  # Qualität auf 85 setzen, um die Dateigröße zu reduzieren
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
