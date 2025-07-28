
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/auth_repository.dart';
import 'data/repositories/chat_repository.dart';
import 'data/repositories/message_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/socket_service.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/chat/chat_bloc.dart';
import 'presentation/bloc/message/message_bloc.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ApiService _apiService = ApiService();
  final SocketService _socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(_apiService),
          ),
        ),
        BlocProvider<ChatBloc>(
          create: (context) => ChatBloc(
            chatRepository: ChatRepository(_apiService),
          ),
        ),
        BlocProvider<MessageBloc>(
          create: (context) => MessageBloc(
            messageRepository: MessageRepository(_apiService, ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Qurinom Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

