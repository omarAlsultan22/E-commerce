import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:international_cuisine/core/data/data_sources/remote/auth_service_impl.dart';


void main() {
  late MockFirebaseAuth mockAuth;
  late AuthServiceImpl authService;

  setUp(() {
    mockAuth = MockFirebaseAuth(
      mockUser: MockUser(uid: 'uid-123', email: 'a@b.com'),
      signedIn: false,
    );
    authService = AuthServiceImpl(auth: mockAuth);
  });

  group('signIn', () {
    test('returns UserCredential on valid credentials', () async {
      final result = await authService.signIn(
        email: 'a@b.com',
        password: 'password123',
      );

      expect(result.user, isNotNull);
      expect(result.user!.uid, 'uid-123');
    });

    test('updates currentUser after sign in', () async {
      await authService.signIn(email: 'a@b.com', password: 'p');

      expect(mockAuth.currentUser, isNotNull);
    });
  });

  group('signUp', () {
    test('returns UserCredential on valid sign up', () async {
      final result = await authService.signUp(
        email: 'new@b.com',
        password: 'password123',
      );

      expect(result.user, isNotNull);
      expect(result.user!.email, 'new@b.com');
    });
  });

  group('updateProfile', () {
    test('returns currentUser when signed in', () async {
      await authService.signIn(email: 'a@b.com', password: 'p');

      final result = await authService.updateProfile(
        newEmail: 'new@b.com',
        currentPassword: 'old',
        newPassword: 'new',
      );

      expect(result, isNotNull);
      expect(result!.uid, 'uid-123');
    });

    test('returns null when not signed in', () async {
      final result = await authService.updateProfile(
        newEmail: 'new@b.com',
        currentPassword: 'old',
        newPassword: 'new',
      );

      expect(result, isNull);
    });
  });

  group('sendResetEmail', () {
    test('completes without error', () async {
      await expectLater(
        authService.sendResetEmail(userEmail: 'a@b.com'),
        completes,
      );
    });
  });

  group('signOut', () {
    test('clears currentUser after sign out', () async {
      await authService.signIn(email: 'a@b.com', password: 'p');
      expect(mockAuth.currentUser, isNotNull);

      await authService.signOut();

      expect(mockAuth.currentUser, isNull);
    });
  });
}