import requests
import json
import time

class BackendCommunicator:
    def __init__(self, api_url: str):
        self.api_url = api_url

    def send_plate_to_backend(self, registration_plate: str) -> None:
        try:
            headers = {'Content-Type': 'application/json'}
            payload = json.dumps({'registration_plate': registration_plate})
            response = requests.post(self.api_url, data=payload, headers=headers, timeout=30)
            response.raise_for_status()
            response_json = response.json()
            is_car_able_to_enter = response_json.get('message', False)

            if is_car_able_to_enter:
                print("Car is on the list!")
                print("Opening the gate ...")
                time.sleep(30)
                print ("Closing the gate ...")
            else:
                print("Car is not on the list!")

        except requests.exceptions.RequestException as e:
            print(f"Request Error: {e}")
        except json.JSONDecodeError as e:
            print(f"JSON Decode Error: {e}. Response text: {response.text if 'response' in locals() else 'No response'}")
        except Exception as e:
            print(f"An unexpected error occurred: {e}")

        print(f"Plate: {registration_plate}, Backend Response: {response_json}")
        time.sleep(5)