---

// README.md
# Qurinom Chat Application

A Flutter chat application built for Qurinom Solutions technical assignment featuring real-time messaging, user authentication, and MVVM architecture with Bloc state management.

## Features

- **Dual User Authentication**: Support for both Customer and Vendor login
- **Real-time Messaging**: Socket.io integration for instant messaging
- **Chat List**: View all conversations for the logged-in user
- **Message History**: Retrieve and display chat history between users
- **MVVM Architecture**: Clean architecture with separation of concerns
- **Bloc State Management**: Reactive state management using flutter_bloc
- **Responsive UI**: Modern Material Design interface

## Architecture

The application follows MVVM (Model-View-ViewModel) architecture with the following layers:

### Data Layer
- **Models**: Data models with JSON serialization (`user_model.dart`, `chat_model.dart`, `message_model.dart`)
- **Services**: API and Socket services (`api_service.dart`, `socket_service.dart`)
- **Repositories**: Data access abstraction layer

### Presentation Layer
- **Bloc**: State management with flutter_bloc
- **Pages**: UI screens (`login_page.dart`, `home_page.dart`, `chat_page.dart`)

## API Endpoints

- **Base URL**: `http://45.129.87.38:6065/`
- **Login**: `POST /user/login`
- **Get User Chats**: `GET /chats/user-chats/:userId`
- **Get Messages**: `GET /messages/get-messagesformobile/:chatId`
- **Send Message**: `POST /messages/sendMessage`

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone or create the project**:
   ```bash
   flutter create qurinom_chat_app
   cd qurinom_chat_app
   ```

2. **Replace the contents** with the provided code files

3. **Install dependencies**:
   ```bash
   flutter pub get
   ```

4. **Generate model files**:
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the application**:
   ```bash
   flutter run
   ```

### Build APK

To build the APK file for submission:

```bash
flutter build apk --release
```

The APK file will be located at: `build/app/outputs/flutter-apk/app-release.apk`

## Test Credentials

Use these credentials for testing:
- **Email**: `swaroop.vass@gmail.com`
- **Password**: `@Tyrion99`
- **Role**: `vendor`

## Project Structure

```
lib/
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── chat_model.dart
│   │   └── message_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── chat_repository.dart
│   │   └── message_repository.dart
│   └── services/
│       ├── api_service.dart
│       └── socket_service.dart
├── presentation/
│   ├── bloc/
│   │   ├── auth/
│   │   ├── chat/
│   │   └── message/
│   └── pages/
│       ├── login_page.dart
│       ├── home_page.dart
│       └── chat_page.dart
└── main.dart
```

## Key Features Implementation

### 1. Authentication
- Login with email, password, and role selection
- JWT token storage using SharedPreferences
- Automatic session management

### 2. Chat List
- Displays all user conversations
- Shows last message and timestamp
- Pull-to-refresh functionality
- Empty state handling

### 3. Real-time Chat
- Socket.io integration for real-time messaging
- Message history loading
- Auto-scroll to new messages
- Typing indicators (ready for implementation)

### 4. State Management
- **AuthBloc**: Handles authentication state
- **ChatBloc**: Manages chat list state
- **MessageBloc**: Controls message flow and socket connections

## Error Handling

The application includes comprehensive error handling:
- Network connectivity issues
- API errors with user-friendly messages
- Socket connection failures
- Empty states and loading indicators

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.3      # State management
  http: ^1.1.0              # HTTP requests
  shared_preferences: ^2.2.2 # Local storage
  socket_io_client: ^2.0.3+1 # Real-time communication
  equatable: ^2.0.5         # Value equality
  json_annotation: ^4.8.1   # JSON serialization

dev_dependencies:
  json_serializable: ^6.7.1 # Code generation
  build_runner: ^2.4.7      # Build system
```

## Notes

- The application is designed to work with the provided API endpoints
- Socket.io connection is established for real-time messaging
- All user data is stored locally using SharedPreferences
- The UI is responsive and follows Material Design guidelines
- Error states are handled gracefully with retry options

## Submission Checklist

- ✅ Login functionality with Customer/Vendor options
- ✅ Home page showing list of chats
- ✅ Chat page with message history
- ✅ Real-time messaging with Socket.io
- ✅ Bloc state management
- ✅ MVVM architecture
- ✅ API integration with provided endpoints
- ✅ APK build ready
- ✅ GitHub repository ready for public sharing

## Future Enhancements

- Push notifications
- Image/file sharing
-// pubspec.yaml
name: qurinom_chat_app
description: A Flutter chat application for Qurinom Solutions assignment

publish_to: 'none'

version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3
  http: ^1.1.0
  shared_preferences: ^2.2.2
  socket_io_client: ^2.0.3+1
  equatable: ^2.0.5
  json_annotation: ^4.8.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  json_serializable: ^6.7.1
  build_runner: ^2.4.7

flutter:
  uses-material-design: true

---
