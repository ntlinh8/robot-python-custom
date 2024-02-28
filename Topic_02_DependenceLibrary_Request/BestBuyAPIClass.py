import requests
import json
from robot.api.deco import library, keyword


@library
class BestBuyAPIClass:
    def __init__(self, url="http://localhost:3030/"):
        self.base_url = url
        self.response = object
        self.current_session = requests.Session()

    @keyword
    def get_all_products(self):
        try:
            self.response = self.current_session.get(self.base_url, headers={"Accept": "application/json"})
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)
        response_json = self.response.json()
        print(response_json)
        return response_json

    @keyword
    def create_new_product(self, information: dict):
        data = json.dumps(information)
        try:
            self.response = self.current_session.post(self.base_url, data=data, headers={"Content-Type": "application/json", "Accept": "application/json"})
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)
        response_json = self.response.json()
        print(response_json)
        return response_json["id"]

    @keyword
    def delete_product_by_id(self, id: str):
        try:
            self.response = self.current_session.delete(self.base_url + f"/{id}", headers={"Accept": "application/json"})
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)
        response_json = self.response.json()
        print(response_json)
        return self.response.status_code


    @keyword
    def get_product_information_by_id(self, id: str):
        try:
            self.response = self.current_session.get(self.base_url + f"/{id}", headers={"Accept": "application/json"})
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)
        response_json = self.response.json()
        print(response_json)
        return response_json

    @keyword
    def update_product_information(self, id: str, information: dict):
        data = json.dumps(information)
        try:
            self.response = self.current_session.patch(self.base_url + f"/{id}", data=data, headers={"Content-Type": "application/json", "Accept": "application/json"})
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)
        response_json = self.response.json()
        print(response_json)
        return response_json
