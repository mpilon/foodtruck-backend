import flask
from flask import request, jsonify
from flask_cors import CORS
import json

app = flask.Flask(__name__)
CORS(app) ## REMOVE FOR PROD
app.config["DEBUG"] = True

# Create some test data for our catalog in the form of a list of dictionaries.

@app.route('/', methods=['GET'])
def home():
    return '''<h1>Foodtruck Backend</h1>
<p>Endpoints for FoodTruck Assistant</p>'''


# A route to return all of the available entries in our catalog.
@app.route('/api/v1/resources/trucks/all', methods=['GET'])
def api_all():
    # https://data.sfgov.org/api/views/rqzj-sfat/rows.csv
    import pandas as pd
    ##data = pd.read_csv('https://data.sfgov.org/api/views/rqzj-sfat/rows.csv')
    data = pd.read_csv('/Users/facultyupca/Desktop/Mobile_Food_Facility_Permit.csv')
    #for row in data:
    #    print(row)
    #return data.to_json(orient='records')[1:-1].replace('},{', '} {')
    lat_lon = data[["Applicant","Address","FoodItems","Latitude", "Longitude"]]

    return {"trucks": lat_lon.fillna('').to_dict(orient='records')}

app.run()
