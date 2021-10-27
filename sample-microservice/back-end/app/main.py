from flask import request
from flask import Flask
import os
import json
import uuid
import boto3

app = Flask(__name__)
resource_collection_name = 'Services'
dynamodb_table = f"{os.environ['NAMESPACE']}-services"
dynamodb = boto3.resource('dynamodb')

@app.route("/create", methods=['POST'])
def dynamodb_create():
    request_json = request.get_json()

    request_json['_id'] = str(uuid.uuid1())

    table = dynamodb.Table(dynamodb_table)
    table.put_item(Item=request_json)

    return {'insertedId': request_json['_id'] }, 201

@app.route("/list", methods=['GET'])
def dynamodb_list():
    table = dynamodb.Table(dynamodb_table)
    scan_result = table.scan()
    response = {
        "count": scan_result['Count'],
        "data": scan_result['Items']
    }
    return { 'data': response }, 200


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5050)