import 'package:agenda/layers/domain/auth/entity/login.dart';
import 'package:agenda/layers/domain/auth/repository/login/login_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginRepoImpl implements LoginRepository {
  @override
  Future<bool> login(Login login) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: login.email ?? '', password: login.password ?? '');
      return true;
    } on FirebaseException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}


// class LoginRepoImpl implements LoginRepository {
//   @override
//   Future<bool> login(Login login) async {
//     try {
//       // AppCheck-ni tekshirish va foydalanuvchi ma'lumotlarini olish
//       await FirebaseAppCheck.instance.verifyAppCheckToken();

//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: login.email ?? '', password: login.password ?? '');
//       return true;
//     } on FirebaseException catch (e) {
//       debugPrint(e.message);
//       return false;
//     }
//   }
// }