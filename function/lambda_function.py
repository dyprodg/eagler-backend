import boto3
from PIL import Image
from io import BytesIO
import os

s3_client = boto3.client('s3')

def lambda_handler(event, context):
    source_bucket = event['Records'][0]['s3']['bucket']['name']
    key = event['Records'][0]['s3']['object']['key']

    # Load the image from the S3 bucket
    file = s3_client.get_object(Bucket=source_bucket, Key=key)
    file_content = file['Body'].read()

    # Image processing: Crop and compress
    image = Image.open(BytesIO(file_content))
    image = image.resize((1080, 1080))  # Example for cropping/compressing

    # Save the processed image temporarily
    buffer = BytesIO()
    image.save(buffer, 'JPEG')  # Save all images as JPEG
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