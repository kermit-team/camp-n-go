import os
from plate_recognition.plate_recognizer import PlateRecognizer

os.environ["API_URL"]="http://localhost:8000/api/cars/entry/"

def main():
	api_url = os.environ.get("API_URL")
	model_path = os.path.join(os.getcwd(), 'models', 'best.pt') 

	if not api_url:
		raise ValueError("API_URL environment variables must be set.")

	recognizer = PlateRecognizer(model_path = model_path, api_url = api_url)
	recognizer.detect_on_webcam()

if __name__ == "__main__":
	main()