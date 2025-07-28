import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthRepository {
  final ApiService _apiService;

  AuthRepository(this._apiService);

  Future<UserModel> login({
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _apiService.login(
      email: email,
      password: password,
      role: role,
    );

    print('Login API response: $response');

    final data = response['data'];
    if (data == null) {
      throw Exception("Login failed: No data returned from server");
    }

    final userJson = data['user'];
    final token = data['token'];

    if (userJson == null) {
      throw Exception("Login failed: User data missing in response");
    }

    
    final fullUserJson = {
      ...userJson as Map<String, dynamic>,
      'token': token,
    };
    final user = UserModel.fromJson(fullUserJson);

    
    await _saveUserData(user);

    return user;
  }

  Future<void> _saveUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', user.id);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_role', user.role);
    await prefs.setString('user_name', user.name ?? '');
    if (user.token != null) {
      await prefs.setString('user_token', user.token!);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final userEmail = prefs.getString('user_email');
    final userRole = prefs.getString('user_role');

    if (userId != null && userEmail != null && userRole != null) {
      return UserModel(
        id: userId,
        email: userEmail,
        role: userRole,
        name: prefs.getString('user_name'),
        token: prefs.getString('user_token'),
      );
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
