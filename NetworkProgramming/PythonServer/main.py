from flask import Flask
from flask import jsonify

app = Flask(__name__)

@app.route('shuaibin/login/')
def login_json():
json_data = {'user': {'username': 'shuaibin', 'passwork':'123'}}
return jsonify(json_data)


if __name__ == '__main__':
app.run(host = '0.0.0.0', port = 8089, debug = True)
