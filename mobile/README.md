# Camp'n'Go

## Description

Camp'n'Go is a mobile application for booking reservations at camping site. </br> 
It provides a user-friendly interface for browsing available camping plots, selecting dates, and making reservations.

## Supported Devices

*   Android (now)
*   iOS (planned for future development)

## Requirements

*   **Flutter SDK:** 3.24.4 or higher
*   **Android Virtual Device (AVD) / iOS Simulator:** Refer to the Flutter installation instructions for recommended configurations: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)
*   **Development Environment:** Follow the instructions on the Flutter website for setting up your development environment: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

## Setup and Installation

1. **Install dependencies:**

        flutter pub get
 
2. **Generate required files:**

        flutter pub run build_runner build --delete-conflicting-outputs</br>
        flutter pub run easy_localization:generate -S "assets/translations" -O "lib/generated" -f keys -o locale_keys.g.dart

## Running the Application

1.  **Connect a device or start an emulator:**

    Refer to the Flutter installation instructions for details on connecting a physical device or starting an emulator/simulator: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

2.  **Run the app:**

        flutter run

## Key Libraries Used

*   **Flutter Bloc:** For state management and business logic.
*   **Go Router:** For navigation and routing.
*   **Easy Localization:** For internationalization and localization.
*   **Retrofit:** For making network requests to a REST API.
*   **Dio:** For HTTP communication.
*   **Flutter Secure Storage:** For securely storing sensitive data.
*   **Google Fonts:** For using custom fonts.
*   **Sizer:** For responsive UI design.
*   **Intl Phone Field:** For inputting phone numbers with international formatting.
