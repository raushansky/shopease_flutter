import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';

class AuthController extends ChangeNotifier {
  bool _isLoading = false;
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;
  String? get userEmail => _userEmail;
  String? get errorMessage => _errorMessage;

  // Check login status from SharedPreferences
  Future<bool> checkLoginStatus() async {
    _isLoggedIn = await SessionManager.isLoggedIn();
    if (_isLoggedIn) {
      _userEmail = await SessionManager.getSavedEmail();
    }
    notifyListeners();
    return _isLoggedIn;
  }

  // Handle Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await ApiService.login(email, password);
      await SessionManager.setLoggedIn(true, email: email);
      _isLoggedIn = true;
      _userEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Official Native Google Sign-In
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      GoogleSignInAccount? account;

      // 1. Try standard native Android sign in
      try {
        final GoogleSignIn nativeSignIn = GoogleSignIn(
          scopes: ['email', 'profile'],
        );
        await nativeSignIn.signOut().catchError((_) => null);
        account = await nativeSignIn.signIn();
      } catch (nativeError) {
        debugPrint('Standard Google Sign-In failed, trying serverClientId: $nativeError');
        // 2. Try with Web Server Client ID as fallback
        final GoogleSignIn webSignIn = GoogleSignIn(
          serverClientId: '836789041948-gp9qlcbabthe2q14sodteef6t4819aoj.apps.googleusercontent.com',
          scopes: ['email', 'profile'],
        );
        await webSignIn.signOut().catchError((_) => null);
        account = await webSignIn.signIn();
      }

      if (account == null) {
        // User closed or canceled account selection
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final String googleEmail = account.email;

      // Save persistent login session
      await SessionManager.setLoggedIn(true, email: googleEmail);
      _isLoggedIn = true;
      _userEmail = googleEmail;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Google Sign-In Exception: $e');
      final errStr = e.toString();
      if (errStr.contains('12501') || errStr.contains('SIGN_IN_CANCELLED')) {
        _errorMessage = null;
      } else {
        _errorMessage = 'Google Sign-In error: ${errStr.replaceAll('PlatformException', '').replaceAll('Exception: ', '')}';
      }
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Handle Signup
  Future<bool> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.signup(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      if (response['success'] == false || response['status'] == 'error') {
        throw Exception(
          response['message'] ?? response['error'] ?? 'Registration failed',
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Handle Logout
  Future<void> logout() async {
    await SessionManager.logout();
    _isLoggedIn = false;
    _userEmail = null;
    notifyListeners();
  }
}
