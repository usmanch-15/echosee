import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:echo_see_companion/data/models/user_model.dart';
import 'package:echo_see_companion/data/repositories/user_repository.dart';
import 'package:echo_see_companion/providers/auth_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

// Mock classes
class MockUserRepository extends Mock implements UserRepository {}
class MockSupabaseClient extends Mock implements supabase.SupabaseClient {}
class MockGotruePlatform extends Mock implements supabase.GoTrueClient {}

void main() {
  late AuthProvider authProvider;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    
    // AuthProvider constructor calls _initialize() which tries to get current user.
    // We need to stub this before creating the provider instantiation if possible,
    // or handle the fact that it's called in constructor.
    when(() => mockUserRepository.getCurrentUser()).thenAnswer((_) async => null);
    
    authProvider = AuthProvider.test(mockUserRepository);
  });

  group('AuthProvider Tests', () {
    final testUser = User(
      id: '123',
      name: 'John Doe',
      email: 'john@example.com',
      createdAt: DateTime.now(),
      isPremium: true,
      preferences: {},
      usageStats: UsageStats(
        totalTranscripts: 0,
        totalMinutes: 0,
        languagesUsed: 0,
        lastActive: DateTime.now(),
        languageDistribution: {},
        dailyUsage: {},
      ),
    );

    test('Initial state is unauthenticated and not loading', () {
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.isLoading, false);
      expect(authProvider.currentUser, null);
    });

    test('Successful login updates user and isAuthenticated', () async {
      // Arrange
      when(() => mockUserRepository.login('john@example.com', 'password123'))
          .thenAnswer((_) async => testUser);

      // Act
      final result = await authProvider.login('john@example.com', 'password123');

      // Assert
      expect(result, true);
      expect(authProvider.isAuthenticated, true);
      expect(authProvider.currentUser, testUser);
      expect(authProvider.isPremium, true);
      verify(() => mockUserRepository.login('john@example.com', 'password123')).called(1);
    });

    test('Failed login sets error and isAuthenticated is false', () async {
      // Arrange
      when(() => mockUserRepository.login('wrong@email.com', 'wrong'))
          .thenThrow(Exception('Invalid credentials'));

      // Act
      final result = await authProvider.login('wrong@email.com', 'wrong');

      // Assert
      expect(result, false);
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.error, contains('Invalid credentials'));
    });

    test('Logout clears user state', () async {
      // Arrange
      when(() => mockUserRepository.login(any(), any())).thenAnswer((_) async => testUser);
      when(() => mockUserRepository.logout()).thenAnswer((_) async => {});
      await authProvider.login('john@example.com', 'password123');

      // Act
      await authProvider.logout();

      // Assert
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, null);
      verify(() => mockUserRepository.logout()).called(1);
    });
  });
}

// Note: I need to add a test constructor to AuthProvider to inject the repository
