# easy_firebase_notification

`easy_firebase_notification` is a Flutter package that simplifies the process of integrating Firebase Cloud Messaging (FCM) notifications with local notifications in your Flutter app. It provides a convenient interface for subscribing to topics, handling background and foreground notifications, and displaying local alerts.

## Features

- Receive and handle Firebase Cloud Messaging notifications.
- Display local notifications with customizable settings.
- Support for both Android and iOS platforms.
- Topic subscription and unsubscription.
- Simple dialog for handling notifications.

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  easy_firebase_notification: ^latest_version
```
Run ```flutter pub get``` to install the package.
## Setup

- Firebase Setup: Make sure your Firebase project is set up correctly and you've added Firebase to your Flutter project. You can follow the official documentation for adding Firebase to Flutter: Firebase Flutter Setup.

## Usage
- Initialize the Package

Before using the package, initialize it by calling the start method in your main app code. You can pass custom alert dialogs, app title, and topics if needed.

```dart
import 'package:easy_firebase_notification/easy_firebase_notification.dart';

// Inside your main function or initialization code
EasyFirebaseNotification.start(
  context: context,
  appTitle: "MyApp",
  allTopic: "all",
  alertDialog: ({required String title, required String body}) {
    return AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    );
  },
);
```

- Subscribe to a Topic

You can subscribe a device to a specific topic to receive notifications related to that topic.

```dart
EasyFirebaseNotification.addTopic("your_topic");
```

- Unsubscribe from a Topic

You can also unsubscribe from a topic.

```dart
EasyFirebaseNotification.removeTopic("your_topic");
```

- Get the Device Token

To get the FCM device token, use the getToken method.

```dart
String token = await EasyFirebaseNotification.getToken();
print("FCM Token: $token");
```

- Handle Notifications

The package automatically listens for incoming messages and displays local notifications. It will also show an alert dialog when a notification is tapped.

## Customization

Custom Alert Dialog: You can pass a custom dialog function to display notifications as dialogs.
App Title: Set a custom app title to be used in the notifications.

## Example

```dart
import 'package:easy_firebase_notification/easy_firebase_notification.dart';
import 'package:flutter/material.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  EasyFirebaseNotification.start(
    context: context,
    appTitle: "My App",
    allTopic: "all",
  );
  runApp(
      MaterialApp(
        title: 'Firebase Notification Demo',
        home: Scaffold(
          appBar: AppBar(
            title: Text('Firebase Notification Demo'),
          ),
          body: Center(
            child: Text('Initialize Notifications'),
          ),
        ),
      ),
  );
}
```

## Platform Support

- Android
- iOS

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests to improve the package.
## License

This package is open-source and available under the MIT License.