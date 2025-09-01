import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../di/di.dart';

class UserService {
  static final _box = sl<Box<dynamic>>(instanceName: 'UserBox');
  final FirebaseFirestore db = FirebaseFirestore.instance;

  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';

  static Future<void> saveAccessToken(String accessToken) async {
    await _box.put(_accessTokenKey, accessToken);
  }

  static Future<void> saveRefreshToken(String refreshToken) async {
    await _box.put(_refreshTokenKey, refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _box.get(_accessTokenKey) as String?;
  }

  static Future<String?> getRefreshToken() async {
    return await _box.get(_refreshTokenKey) as String?;
  }

  static Future<void> deleteUser() async {
    await _box.clear();
  }

  /// Firebase'da anonim autentifikatsiya qilish
  static Future<User?> signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      final user = userCredential.user;

      if (user != null) {
        debugPrint("Anonim foydalanuvchi tizimga kirdi: ${user.uid}");
        await fetchAndSaveTokens(); // Tokenlarni olib saqlash
      }

      return user;
    } catch (e) {
      debugPrint("Anonim autentifikatsiyada xatolik: $e");
      return null;
    }
  }

  /// Foydalanuvchini register qilish
  static Future<User?> registerWithEmailPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        debugPrint("Foydalanuvchi ro'yxatdan o'tdi: ${user.email}");
        await fetchAndSaveTokens();
      }

      return user;
    } catch (e) {
      debugPrint("Ro'yxatdan o'tishda xatolik: $e");
      return null;
    }
  }

  /// Tokenlarni Firebase'dan olib Hive'ga saqlash
  static Future<void> fetchAndSaveTokens() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final accessToken = await user.getIdToken();
        await saveAccessToken(accessToken.toString());

        final refreshToken = user.refreshToken;
        if (refreshToken != null) {
          await saveRefreshToken(refreshToken);
        }
      } else {
        debugPrint('Foydalanuvchi tizimga kirmagan');
      }
    } catch (e) {
      debugPrint('Tokenlarni olishda xatolik: $e');
    }
  }
}
