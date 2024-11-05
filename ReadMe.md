# Reddit Clone

A Reddit-like application built with Dart and Flutter, utilizing Firebase for authentication, database, and storage. This app allows users to create posts, comment, and engage with others in a community-like environment.

## Features

- User authentication with Firebase
- Create, edit, and delete posts
- Comment on posts
- Google sign-in integration
- Local storage using shared preferences

## Dependencies

This project uses the following dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4
  google_sign_in: ^6.2.1
  flutter_riverpod: ^2.6.1
  firebase_storage: ^12.3.4
  fpdart: ^1.1.0
  routemaster: ^1.0.1
  dotted_border: ^2.1.0
  file_picker: ^8.1.3
  shared_preferences: ^2.3.2
  uuid: ^4.5.1
  any_link_preview: ^3.0.2
```

## Setup Instructions

Follow these steps to set up and run the project locally:

### Prerequisites

1. Ensure you have [Flutter](https://flutter.dev/docs/get-started/install) installed on your machine.
2. Make sure you have a compatible IDE, such as [Android Studio](https://developer.android.com/studio) or [Visual Studio Code](https://code.visualstudio.com/).

### Firebase Setup

1. **Create a Firebase Project:**

   - Go to the [Firebase Console](https://console.firebase.google.com/).
   - Click on "Add project" and follow the instructions to create a new project.

2. **Register Your App:**

   - In your Firebase project, click on "Add app" and select "Web".
   - Follow the instructions to register your app.

3. **Run FlutterFire Configuration:**

   - Navigate to your Flutter project directory.
   - Run the following command to configure Firebase for your Flutter app:

   ```bash
   flutterfire configure
   ```

   This command will automatically set up the required Firebase dependencies and configuration files.

4. **iOS Setup (if targeting iOS):**

   - Navigate to your Flutter project directory.
   - Open the `ios` folder and edit the `Podfile` to add the following:

   ```ruby
   platform :ios, '13.0' # Ensure you have this or higher
   use_frameworks!
   ```

   - Run the following command in the terminal from the `ios` directory:

   ```bash
   pod install
   ```

### Run the App

Use the following command to run your app:

```bash
flutter run
```

### Additional Information

- For more detailed documentation on FlutterFire, visit the [FlutterFire documentation](https://firebase.flutter.dev/docs/overview).
- Make sure to handle user authentication and Firestore rules in your Firebase console for better security.

### Screenshots
<img src="https://github.com/user-attachments/assets/0f035764-cfe0-44e9-a2b6-7473d0a1f62a" alt="Homescreen" width="184" height="400"/>
<img src="https://github.com/user-attachments/assets/4a87580c-f78b-4dfb-8a78-21cef9d03d6c" alt="Drawer" width="184" height="400"/>
<img src="https://github.com/user-attachments/assets/9cdc7fe1-a4bb-4191-a191-05bb0cd52f70" alt="Profile Screen" width="184" height="400"/>
<img src="https://github.com/user-attachments/assets/58cf44ba-17ea-48dc-9fe1-248474855665" alt="Community Profile" width="184" height="400"/>




## Contribution!


Contributions are welcome! Please feel free to submit a pull request or raise an issue.
