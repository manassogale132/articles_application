# Articles Application

![1000005041](https://github.com/user-attachments/assets/7836bbde-1929-4af4-8911-a9c1ddc50e36)

A Flutter application for browsing and reading articles.

## Features

- Browse articles list
- Search articles
- View article details
- Pull to refresh
- Favorite articles
- Color-coded article identifiers
- Responsive design for multiple device sizes

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK (^3.7.2)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository
   ```
   git clone https://github.com/yourusername/articles_application.git
   ```

2. Navigate to the project directory
   ```
   cd articles_application
   ```

3. Install dependencies
   ```
   flutter pub get
   ```

4. Run the app
   ```
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── models/                # Data models
├── providers/             # State management
│   └── article_provider.dart
├── screens/               # UI screens
│   └── article_list_screen.dart
├── utils/                 # Utility functions
│   └── color_generator.dart
└── widgets/               # Reusable UI components
    └── id_avatar.dart
```

## Dependencies

- [provider](https://pub.dev/packages/provider) - State management
- [dio](https://pub.dev/packages/dio) - HTTP client
- [shared_preferences](https://pub.dev/packages/shared_preferences) - Local Storage
