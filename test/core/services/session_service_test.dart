import 'package:flutter_test/flutter_test.dart';
import 'package:international_cuisine/core/services/session_service.dart';

import '../../fakes/fake_cache_helper.dart';


void main() {
  late SessionService session;
  late FakeCacheHelper fakeCache;

  setUp(() {
    fakeCache = FakeCacheHelper();
    session = SessionService(cacheHelper: fakeCache);
  });

  group('initial state', () {
    test('currentUid is empty', () {
      expect(session.currentUid, '');
    });

    test('isLoggedIn is false', () {
      expect(session.isLoggedIn, false);
    });
  });

  group('loadFromStorage', () {
    test('loads uid from cache when present', () async {
      await fakeCache.setString(key: 'user_id', value: 'uid-123');

      await session.loadFromStorage();

      expect(session.currentUid, 'uid-123');
      expect(session.isLoggedIn, true);
    });

    test('sets empty uid when cache is empty', () async {
      await session.loadFromStorage();

      expect(session.currentUid, '');
      expect(session.isLoggedIn, false);
    });

    test('reads from "user_id" key only', () async {
      await fakeCache.setString(key: 'other_key', value: 'other-uid');

      await session.loadFromStorage();

      expect(session.currentUid, '');
    });
  });

  group('login', () {
    test('updates currentUid and saves to cache', () async {
      await session.login('uid-456');

      expect(session.currentUid, 'uid-456');
      expect(session.isLoggedIn, true);
      expect(await fakeCache.getString(key: 'user_id'), 'uid-456');
    });

    test('overwrites previous uid', () async {
      await session.login('uid-1');
      await session.login('uid-2');

      expect(session.currentUid, 'uid-2');
      expect(await fakeCache.getString(key: 'user_id'), 'uid-2');
    });
  });

  group('logout', () {
    test('clears currentUid and removes from cache', () async {
      await session.login('uid-123');
      await session.logout();

      expect(session.currentUid, '');
      expect(session.isLoggedIn, false);
      expect(await fakeCache.getString(key: 'user_id'), '');
    });

    test('logout when already logged out is safe', () async {
      await session.logout();

      expect(session.currentUid, '');
    });
  });
}