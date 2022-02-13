import flask
from flask import request, jsonify
import json
import os
import logging
from redis import Redis
from flask_cors import CORS

## TODO: GET FROM ENV
env="prod"

## Set up App
app = flask.Flask(__name__)
app.config["DEBUG"] = True

## TODO: REMOVE FOR PROD
CORS(app)

# Set up Redis
#redis = Redis(host=os.environ.get('ELASTICACHE_REDIS_ADDRESS'), port=6379)
#redis = Redis(host='prod-ftfp-redis.srpgwa.0001.use1.cache.amazonaws.com, port=6379, decode_responses=True, ssl=True, username='myuser', password='MyPassword0123456789')

#if redis.ping():
#    logging.info("Connected to Redis")

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Foodtruck Backend</h1>'''

# A route to return all of the available entries in our catalog.
@app.route('/api/v1/resources/trucks/all', methods=['GET'])
def api_all():
    
    import pandas as pd
    data = pd.read_csv('https://data.sfgov.org/api/views/rqzj-sfat/rows.csv')

    lat_lon = data[["Applicant","Address","FoodItems","Latitude", "Longitude"]]

    return {"trucks": lat_lon.fillna('').to_dict(orient='records')}

