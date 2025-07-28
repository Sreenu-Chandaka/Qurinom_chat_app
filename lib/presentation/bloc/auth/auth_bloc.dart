import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    print('AuthBloc initialized');
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('LoginRequested event received');
    emit(AuthLoading());
    try {
      final user = await authRepository.login(
        email: event.email,
        password: event.password,
        role: event.role,
      );
      print('User authenticated: $user');
      emit(AuthAuthenticated(user));
    } catch (e) {
      print('Login error: $e');
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    print('LogoutRequested event received');
    await authRepository.logout();
    print('User logged out');
    emit(AuthUnauthenticated());
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    print('CheckAuthStatus event received');
    final user = await authRepository.getCurrentUser();
    if (user != null) {
      print('User is authenticated: $user');
      emit(AuthAuthenticated(user));
    } else {
      print('User is not authenticated');
      emit(AuthUnauthenticated());
    }
  }
}

