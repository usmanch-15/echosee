// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:echo_see_companion/data/models/user_model.dart';
import 'package:echo_see_companion/data/repositories/user_repository.dart';
import 'package:echo_see_companion/data/repositories/supabase_user_repository.dart';

class AuthProvider with ChangeNotifier {
  final UserRepository _userRepository;
  
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isPremium => _currentUser?.isPremium ?? false;

  AuthProvider() : _userRepository = SupabaseUserRepository() {
    _initialize();
  }

  AuthProvider.test(this._userRepository);

  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _userRepository.getCurrentUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    // Listen to auth state changes
    supabase.Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      final event = data.event;
      if (event == supabase.AuthChangeEvent.signedIn) {
        await refreshUser();
      } else if (event == supabase.AuthChangeEvent.signedOut) {
        _currentUser = null;
        notifyListeners();
      } else if (event == supabase.AuthChangeEvent.passwordRecovery) {
        // Navigate to reset password screen
        NavigationService.navigateToAndRemoveUntil('/reset-password');
        notifyListeners();
      }
    });
  }

  Future<void> refreshUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      _currentUser = await _userRepository.getCurrentUser();
    } catch (e) {
      _error = _handleError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.login(email, password);
      return true;
    } catch (e) {
      _error = _handleError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.signup(name, email, password);
      return true;
    } catch (e) {
      _error = _handleError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _userRepository.logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _error = _handleError(e);
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _userRepository.resetPassword(email);
    } catch (e) {
      _error = _handleError(e);
      rethrow;
    }
  }

  Future<bool> updateProfile({required String name, String? imageUrl}) async {
    if (_currentUser == null) return false;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedUser = _currentUser!.copyWith(
        name: name,
        profileImage: imageUrl ?? _currentUser!.profileImage,
      );
      await _userRepository.updateProfile(updatedUser);
      await refreshUser();
      return true;
    } catch (e) {
      _error = _handleError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> togglePremium() async {
    if (_currentUser == null) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newStatus = !isPremium;
      await supabase.Supabase.instance.client
          .from('users')
          .update({'is_premium': newStatus})
          .eq('id', _currentUser!.id);
      
      await refreshUser();
    } catch (e) {
      _error = _handleError(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userRepository.signInWithGoogle();
      await refreshUser();
    } catch (e) {
      _error = _handleError(e);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithFacebook() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _userRepository.signInWithFacebook();
      await refreshUser();
    } catch (e) {
      _error = _handleError(e);
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _handleError(dynamic e) {
    final errorString = e.toString();
    if (errorString.contains('SocketException') || 
        errorString.contains('Network') || 
        errorString.contains('failed to connect')) {
      return 'No internet connection. Please check your network.';
    }
    if (errorString.contains('Invalid login credentials')) return 'Invalid email or password.';
    if (errorString.contains('User already registered')) return 'This email is already registered.';
    
    return errorString;
  }
}
