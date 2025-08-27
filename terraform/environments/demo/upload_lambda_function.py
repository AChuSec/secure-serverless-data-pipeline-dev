import boto3
import os
import json
import urllib.parse
import jwt  # PyJWT library

s3 = boto3.client('s3')

def lambda_handler(event, context):
    try:
        # ---------------------------
        # 1 Token Verification
        # ---------------------------
        token = event['headers'].get('Authorization')
        if not token:
            return {"statusCode": 401, "body": json.dumps({"error": "Unauthorized"})}

        try:
            # Decode and verify JWT token (replace <COGNITO_PUBLIC_KEY> with actual key)
            decoded = jwt.decode(token, "<COGNITO_PUBLIC_KEY>", algorithms=["RS256"])
            user = decoded["username"]
        except Exception:
            return {"statusCode": 401, "body": json.dumps({"error": "Invalid token"})}

        # ---------------------------
        # 2 Get filename from query params
        # ---------------------------
        filename = event['queryStringParameters']['filename']
        filename = urllib.parse.quote(filename)

        bucket_name = os.environ['UPLOAD_BUCKET']

        # validation check to ensure only allowed file types are uploaded
        if not filename.endswith(('.csv', '.pdf')):
            raise ValueError("Invalid file type")

        # ---------------------------
        # 3 Generate presigned URL
        # ---------------------------
        url = s3.generate_presigned_url(
            'put_object',
            Params={'Bucket': bucket_name, 'Key': filename},
            ExpiresIn=300
        )

        return {
            "statusCode": 200,
            "headers": {"Content-Type": "application/json"},
            "body": json.dumps({"upload_url": url})
        }

    except Exception as e:
        return {
            "statusCode": 400,
            "body": json.dumps({"error": str(e)})
        }
