import json
import urllib.parse
import boto3

def lambda_handler(event, context):
    # Initialize the SES client
    ses = boto3.client('ses')
    
    # Parse the incoming form data from API Gateway
    body = urllib.parse.parse_qs(event['body'])
    
    # Extract form fields
    experience = body.get('experience', [''])[0]
    comments = body.get('comments', [''])[0]
    name = body.get('name', [''])[0]
    email = body.get('email', [''])[0]
    
    # Log the received values (you can store them in DynamoDB or another storage if needed)
    print(f"Experience: {experience}")
    print(f"Comments: {comments}")
    print(f"Name: {name}")
    print(f"Email: {email}")
    
    # Create the email parameters
    email_params = {
        'Destination': {
            'ToAddresses': ["sdweerathunga5@gmail.com"]  # Replace with your desired email address
        },
        'Message': {
            'Body': {
                'Text': {
                    'Data': f'Experience: {experience}\nComments: {comments}\nName: {name}\nEmail: {email}'
                }
            },
            'Subject': {
                'Data': f'Feedback received from {name}'
            }
        },
        'Source': "sdweerathunga5@gmail.com"  # Replace with your verified SES email address
    }
    
    # Send the email using AWS SES
    try:
        response = ses.send_email(**email_params)
        print(f"Email sent! Message ID: {response['MessageId']}")
    except Exception as e:
        print(f"Error sending email: {str(e)}")
    
    # Create the response object with CORS headers
    response = {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': 'http://snk-statict-web.s3-website-us-east-1.amazonaws.com'  # Update with your origin
        },
        'body': json.dumps(f'Thank you, {name}! Your feedback was received!')
    }
    
    return response

