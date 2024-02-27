import requests
import json

def get_all_products():
    global response
    try:
        response = requests.get(f"http://localhost:3030/products", headers={"Accept": "application/json"})
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    response_json = response.json()
    print(response_json)
    return response_json

def create_new_product(information: dict):
    global response
    data = json.dumps(information)
    try:
        response = requests.post(f"http://localhost:3030/products", data=data, headers={"Content-Type": "application/json", "Accept": "application/json"})
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    response_json = response.json()
    print(response_json)
    return response_json["id"]

def delete_product_by_id(id: str):
    global response
    try:
        response = requests.delete(f"http://localhost:3030/products/{id}", headers={"Accept": "application/json"})
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    response_json = response.json()
    print(response_json)
    return  response.status_code

def get_product_information_by_id(id: str):
    global response
    try:
        response = requests.get(f"http://localhost:3030/products/{id}", headers={"Accept": "application/json"})
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    response_json = response.json()
    print(response_json)
    return response_json

def update_product_information(id: str, information: dict):
    global response
    data = json.dumps(information)
    try:
        response = requests.patch(f"http://localhost:3030/products/{id}", data=data, headers={"Content-Type": "application/json", "Accept": "application/json"})
    except requests.exceptions.RequestException as e:
        raise SystemExit(e)
    response_json = response.json()
    print(response_json)
    return response_json
