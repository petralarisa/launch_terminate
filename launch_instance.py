import json
import boto3

def lambda_handler(event, context):
    client = boto3.client('ec2')
    response = client.run_instances(

    ImageId='ami-0a887e401f7654935',
    InstanceType='t2.micro',
    #use your keypair and insert below
    KeyName='',
    MaxCount=1,
    MinCount=1,
    Monitoring={
        'Enabled': False
    },

    CreditSpecification={
        'CpuCredits': 'standard'
    },
    Placement={
        'AvailabilityZone': 'us-east-1a',
    },


)
    # TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
