# import the json utility package since we will be working with a JSON object
import json
# import the AWS SDK (for Python the package name is boto3)
import boto3
# import time 
import time
# import two packages to help us with dates and date formatting

# create a DynamoDB object using the AWS SDK
dynamodb = boto3.resource('dynamodb')
# use the DynamoDB object to select our table
table = dynamodb.Table('HelloWorldDatabase')

# define the handler function that the Lambda service will use as an entry point
def lambda_handler(event, context):
 # Get the current GMT time
    gmt_time = time.gmtime()

    # store the current time in a human readable format in a variable
    # Format the GMT time string
    now = time.strftime('%a, %d %b %Y %H:%M:%S +0000', gmt_time)


# extract values from the event object we got from the Lambda service and store in a variable
    name = event['firstName'] +' '+ event['lastName']
# write name and time to the DynamoDB table using the object we instantiated and save response in a variable
    response = table.put_item(
        Item={
            'ID': name,
            'LatestGreetingTime':now
            })
# return a properly formatted JSON object
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda, ' + name)
    }