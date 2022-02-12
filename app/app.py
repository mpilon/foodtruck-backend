import flask
from flask import request, jsonify
import json


## TODO: REMOVE FOR PROD
from flask_cors import CORS

app = flask.Flask(__name__)

## TODO: REMOVE FOR PROD
CORS(app)

app.config["DEBUG"] = True

# Create some test data for our catalog in the form of a list of dictionaries.

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Foodtruck Backend</h1>
<p>Endpoints for FoodTruck Assistant</p>'''

@app.route('/redis-test', methods=['GET'])
def redis_test():
    import boto3
    import botocore
    import os
    import sys

    client = boto3.client('elasticache')

    #response = client.describe_replication_groups(
    #    ReplicationGroupId=os.environ.get('ELASTICACHE_REDIS_REPLICATION_GID')
    #)

    try:
        response = client.describe_replication_groups(
            ReplicationGroupId=os.environ.get('ELASTICACHE_REDIS_REPLICATION_GID')
        )
    except botocore.exceptions.ClientError as error:
        print(error)
        # Put your error handling logic here
        
        ##template = "An exception of type {0} occurred. Arguments:\n{1!r}"
        ##message = template.format(type(ex).__name__, ex.args)
        ##print (message)
        return '''<h1>Client error</h1>'''

    return response
    ##except:
    

# A route to return all of the available entries in our catalog.
@app.route('/api/v1/resources/trucks/all', methods=['GET'])
def api_all():
    
    import pandas as pd
    data = pd.read_csv('https://data.sfgov.org/api/views/rqzj-sfat/rows.csv')

    lat_lon = data[["Applicant","Address","FoodItems","Latitude", "Longitude"]]

    return {"trucks": lat_lon.fillna('').to_dict(orient='records')}

