from typing import Optional
import cv2
import easyocr
import numpy as np
import csv
import uuid
from ultralytics import YOLO
from pathlib import Path
import os
from plate_recognition.backend_communicator import BackendCommunicator

class PlateRecognizer:

    def __init__(self, model_path: str, api_url: Optional[str] = None):
        self.model_path = model_path
        self.model = YOLO(self.model_path)
        self.threshold = 0.8
        self.backend_communicator = BackendCommunicator(api_url) if api_url else None

    def filter_text(self, region: np.ndarray, ocr_result: list, region_threshold: float) -> str:
        rectangle_size = region.shape[0] * region.shape[1]
        for result in ocr_result:
            length = np.sum(np.subtract(result[0][1], result[0][0]))
            height = np.sum(np.subtract(result[0][2], result[0][1]))
            if length * height / rectangle_size > region_threshold:
                return result[1]
            
    def save_results(self, text: list, region: np.ndarray, csv_filename: str, folder_path: str) -> None:
        print(os.getcwd())
        output_path = os.path.join(os.getcwd(), folder_path)
        Path(output_path).mkdir(parents=True, exist_ok=True)
        img_name = '{}.jpg'.format(uuid.uuid1())
        output_img_path = os.path.join(output_path, 'recognized_plate_images')
        Path(output_img_path).mkdir(parents=True, exist_ok=True)
        cv2.imwrite(os.path.join(output_img_path, img_name), region)

        with open(os.path.join(output_path, csv_filename), mode='a', newline='') as f:
            csv_writer = csv.writer(f, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
            csv_writer.writerow([img_name, text])

    def detect_on_webcam(self) -> None:
        cap = cv2.VideoCapture(0)
        ret, frame = cap.read()
        while ret:
            results = self.model(frame)[0]
            for result in results.boxes.data.tolist():
                x1, y1, x2, y2, score, class_id = result
                region = frame[int(y1):int(y2), int(x1):int(x2)]
                if score > self.threshold:
                    if int(class_id) == 0:
                        try:
                            reader = easyocr.Reader(['en'])
                            ocr_result = reader.readtext(region)
                            text = self.filter_text(region, ocr_result, 0.5)
                            cv2.putText(region, f"{text}", (int(x1) + 25, int(y1 - 10)),
                                        cv2.FONT_HERSHEY_SIMPLEX, .25, (0, 0, 255), 1, cv2.LINE_AA)
                            self.save_results(text, region, 'log.csv', 'recognized_plates')
                            if text:
                                cleaned_registration_plate = "".join(text.split())
                                self.backend_communicator.send_plate_to_backend(cleaned_registration_plate)
                            else:
                                print("No text detected in the region.")
                        except Exception as e:
                            print(f"OCR or Backend Error: {e}")
                        except:
                            pass
                    else:
                        cv2.rectangle(frame, (int(x1), int(y1)), (int(x2), int(y2)), (0, 255, 0), 1)
                        cv2.putText(frame, results.names[int(class_id)].upper(), (int(x1), int(y1 - 10)),
                                    cv2.FONT_HERSHEY_SIMPLEX, .4, (255, 0, 0), 1, cv2.LINE_AA)           
            cv2.imshow("frame", frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break
            else:
                ret, frame = cap.read()
        cap.release()
        cv2.destroyAllWindows()
